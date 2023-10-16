class AddVisibleToPoasts < ActiveRecord::Migration[7.0]
  def change
    add_column :poasts, :visible, :boolean, default: true
  end
end
