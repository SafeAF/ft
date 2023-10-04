class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :replies, dependent: :destroy  
  has_many :flags, as: :flaggable, dependent: :destroy

    has_many :notifications, as: :notifiable, dependent: :destroy

  # Callback to create a notification after a comment is saved
  after_create :create_notification

  def create_notification
    if self.commentable.user
      Notification.create(
        user: self.commentable.user,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} commented on your #{self.commentable.class.name.downcase}."
      )
    end
  end
end

