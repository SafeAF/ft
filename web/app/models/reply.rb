class Reply < ApplicationRecord
  belongs_to :comment
  belongs_to :user
  
  has_many :notifications, as: :notifiable, dependent: :destroy

  # Callback to create a notification after a reply is saved
  after_create :create_notification

  def create_notification
    # Notify the user who originally created the comment
    if self.comment.user
      Notification.create(
        user: self.comment.user,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} replied to your comment."
      )
    end
  
    # Notify the user who owns the item (article, listing, etc.) that the comment was made on
    if self.comment.commentable.user && self.comment.commentable.user != self.comment.user
      Notification.create(
        user: self.comment.commentable.user,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} replied to a comment on your #{self.comment.commentable.class.name.downcase}."
      )
    end
  end
  

end
