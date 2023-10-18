class UserBadge < ApplicationRecord
    belongs_to :user
    belongs_to :badge
  
    validates :user_id, uniqueness: { scope: :badge_id, message: "Badge already assigned to this user" }
end
  