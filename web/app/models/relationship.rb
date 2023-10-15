class Relationship < ApplicationRecord
    belongs_to :follower, class_name: 'User'
    belongs_to :followed, class_name: 'User'
  
    validates :follower_id, presence: true
    validates :followed_id, presence: true

    after_create :create_notification

    def create_notification
      Notification.create(
        user: self.followed,
        notifiable: self,
        status: :unread,
        message: "#{self.follower.username} started following you."
      )
    end
  
  end
  