class Reply < ApplicationRecord
  belongs_to :comment
  belongs_to :user
  
  has_many :notifications, as: :notifiable, dependent: :destroy

  # Callback to create a notification after a reply is saved
  after_create :create_notification

  def create_notification
    # Skip notification if the user is replying to their own comment
    if self.comment.user != self.user
      Notification.create(
        user: self.comment.user,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} replied to your comment."
      )
    end
  
    # Determine the owner of the commentable item
    owner = if self.comment.commentable.respond_to?(:user)
              self.comment.commentable.user
            elsif self.comment.commentable.is_a?(User)
              self.comment.commentable
            end
  
    # Notify the owner if they're not the same as the user who created the comment or replied
    if owner && owner != self.user && owner != self.comment.user
      Notification.create(
        user: owner,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} replied to a comment on your #{self.comment.commentable.class.name.downcase}."
      )
    end
  end
  
  
  


  scope :visible, -> { where(visible: true) }
  scope :hidden, -> { where(visible: false) }

  def hide
    update(visible: false)
  end


end
