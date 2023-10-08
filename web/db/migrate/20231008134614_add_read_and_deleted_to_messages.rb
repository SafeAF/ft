class AddReadAndDeletedToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :read, :boolean, default: false
    add_column :messages, :deleted, :boolean, default: false
  end
end
