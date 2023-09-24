class AddFlagsCountToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :flags_count, :integer, default: 0
  end
end
