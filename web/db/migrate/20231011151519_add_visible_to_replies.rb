class AddVisibleToReplies < ActiveRecord::Migration[7.0]
  def change
    add_column :replies, :visible, :boolean, default: true
  end
end
