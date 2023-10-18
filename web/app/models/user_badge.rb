class UserBadge < ApplicationRecord
    belongs_to :user
    belongs_to :badge
  
    validates :user_id, uniqueness: { scope: :badge_id, message: "Badge already assigned to this user" }

    after_create :create_notification

    def create_notification
      Notification.create(
        user: self.user,
        notifiable: self,
        status: :unread,
        message: "You've been awarded the #{self.badge.name} badge!"
      )
    end
  
end
  