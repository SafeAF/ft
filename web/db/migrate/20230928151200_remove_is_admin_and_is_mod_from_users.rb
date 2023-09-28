class RemoveIsAdminAndIsModFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :is_admin, :boolean
    remove_column :users, :is_mod, :boolean
  end
end
