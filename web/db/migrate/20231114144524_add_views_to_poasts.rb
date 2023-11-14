class AddViewsToPoasts < ActiveRecord::Migration[7.0]
  def change
    add_column :poasts, :views, :integer, default: 0
  end
end
