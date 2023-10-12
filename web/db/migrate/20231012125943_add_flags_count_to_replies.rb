class AddFlagsCountToReplies < ActiveRecord::Migration[7.0]
  def change
    add_column :replies, :flags_count, :integer, default: 0
  end
end
