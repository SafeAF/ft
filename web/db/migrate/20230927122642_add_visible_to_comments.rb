class AddVisibleToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :visible, :boolean, default: true
  end
end
