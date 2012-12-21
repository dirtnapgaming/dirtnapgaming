require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "migrating IP.Board user" do
    ipb = users(:legacy_ipb)
    assert ipb.valid_password?('password123')
    assert_nil ipb.legacy_password_hash
    assert_nil ipb.legacy_password_salt
    assert_nil ipb.legacy_encryption_method
    assert_not_nil ipb.encrypted_password
    assert ipb.encrypted_password.present?
    assert ipb.valid_password?('password123')
  end

  test "migrating vBulletin user" do
    vb = users(:legacy_vb)
    assert vb.valid_password?('password123')
    assert_nil vb.legacy_password_hash
    assert_nil vb.legacy_password_salt
    assert_nil vb.legacy_encryption_method
    assert_not_nil vb.encrypted_password
    assert vb.encrypted_password.present?
    assert vb.valid_password?('password123')
  end
end
