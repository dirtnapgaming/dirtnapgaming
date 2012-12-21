require 'digest/md5'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation,
                  :remember_me
  # attr_accessible :title, :body

  # Return true if the password provided by the user is the one in the database.
  # This will also authenticate the a legacy user and migrate that user to
  # Devise.
  def valid_password?(password)
    if legacy_password_hash.present? and legacy_password_salt.present? and legacy_encryption_method.present?
      if Devise.secure_compare(legacy_password_hash, legacy_digest(password))
        self.password = password
        clean_legacy
        self.save!
        true
      else
        false
      end
    else
      super
    end
  end

  # Clean up the legacy fields upon resetting the user's password.
  def reset_password(*args)
    clean_legacy
    super
  end

protected

  # Set the legacy fields to null after the user has been migrated to Devise.
  def clean_legacy
    self.legacy_password_hash = nil
    self.legacy_password_salt = nil
    self.legacy_encryption_method = nil
  end
 
  # Return the hash depending on which encryption method was used by the user. 
  def legacy_digest(password)
    return nil if legacy_encryption_method.blank?

    # Determine the string before passing to the last MD5 hashing function
    str = nil
    if legacy_encryption_method == 'ipboard' # IP.Board Encryption
      str = [Digest::MD5.hexdigest(legacy_password_salt), Digest::MD5.hexdigest(password)].join
    else # vBulletin Encryption
      str = [Digest::MD5.hexdigest(password), legacy_password_salt].join
    end

    Digest::MD5.hexdigest(str).downcase
  end
end
