class Reply < ApplicationRecord
  belongs_to :comment
  belongs_to :user
  
  has_many :notifications, as: :notifiable, dependent: :destroy

  # Callback to create a notification after a reply is saved
  after_create :create_notification

  def create_notification
    # Notify the user who owns the comment being replied to
    Notification.create(user: self.comment.user, notifiable: self, status: :unread) if self.comment.user

    # Notify the user who owns the article (or other parent object) to which the comment was made
    Notification.create(user: self.comment.commentable.user, notifiable: self, status: :unread) if self.comment.commentable.user
  end


end
