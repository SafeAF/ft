class AddUniqueIndexToUserBadges < ActiveRecord::Migration[7.0]
  def change
    add_index :user_badges, [:user_id, :badge_id], unique: true
  end
end
