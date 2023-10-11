class RemoveFlaggedCountFromArticles < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :flagged_count, :integer
  end
end
