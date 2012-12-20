class IndexUsersOnUsername < ActiveRecord::Migration
  def change
    add_index :users, [:username], { :name => 'index_users_on_username',
      :unique => true }
  end
end
