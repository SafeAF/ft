class AddFlagsCountToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :flags_count, :integer, default: 0
  end
end
