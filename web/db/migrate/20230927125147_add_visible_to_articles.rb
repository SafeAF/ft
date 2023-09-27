class AddVisibleToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :visible, :boolean, default: true
  end
end
