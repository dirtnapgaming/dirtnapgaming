class AddLegacyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :legacy_password_hash, :string, :default => nil, :null => true
    add_column :users, :legacy_password_salt, :string, :default => nil, :null => true
    add_column :users, :legacy_encryption_method, :string, :default => nil, :null => true
  end
end
