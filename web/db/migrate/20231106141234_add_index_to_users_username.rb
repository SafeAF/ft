class AddIndexToUsersUsername < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE UNIQUE INDEX index_users_on_lowercase_username
      ON users (LOWER(username))
    SQL
  end

  def down
    remove_index :users, name: :index_users_on_lowercase_username
  end
end
