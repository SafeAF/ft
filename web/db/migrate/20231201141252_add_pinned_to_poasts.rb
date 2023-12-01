class AddPinnedToPoasts < ActiveRecord::Migration[7.0]
  def change
    add_column :poasts, :pinned, :boolean, default: false
  end
end
