class AddPinnedToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :pinned, :boolean, default: false
  end
end
