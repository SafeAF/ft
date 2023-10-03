class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :replies, dependent: :destroy  
  has_many :flags, as: :flaggable, dependent: :destroy

    has_many :notifications, as: :notifiable, dependent: :destroy

  # Callback to create a notification after a comment is saved
  after_create :create_notification

  def create_notification
    # Create the notification
    Notification.create(user: self.commentable.user, notifiable: self, status: :unread) if self.commentable.user
  end
end

