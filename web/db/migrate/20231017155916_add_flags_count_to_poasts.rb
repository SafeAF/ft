class AddFlagsCountToPoasts < ActiveRecord::Migration[7.0]
  def change
    add_column :poasts, :flags_count, :integer, default: 0
  end
end
