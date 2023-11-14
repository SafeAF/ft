class Relationship < ApplicationRecord
    belongs_to :follower, class_name: 'User'
    belongs_to :followed, class_name: 'User'
  

    after_create :create_notification

    def create_notification
      Notification.create(
        user: self.followed,
        notifiable: self,
        status: :unread,
        message: "#{self.follower.username} started following you."
      )
    end

    validates :follower_id, presence: true
    validates :followed_id, presence: true
    validates :follower_id, uniqueness: { scope: :followed_id }
    validate :follower_cannot_be_followed
  
    private
  
    def follower_cannot_be_followed
      errors.add(:follower_id, "can't follow themselves") if follower_id == followed_id
    end
  end
  