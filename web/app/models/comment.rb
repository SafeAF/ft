class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :replies, dependent: :destroy  
  has_many :flags, as: :flaggable, dependent: :destroy

    has_many :notifications, as: :notifiable, dependent: :destroy

  # Callback to create a notification after a comment is saved
  after_create :create_notification

  def create_notification
    # Determine the owner of the commentable item
    owner = if self.commentable.respond_to?(:user)
              self.commentable.user
            elsif self.commentable.is_a?(User)
              self.commentable
            end
  
    if owner
      commentable_type = self.commentable.class.name.downcase
      # Special case for when the commentable is a User
      commentable_type = "profile" if commentable_type == "user"
  
      Notification.create(
        user: owner,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} commented on your #{commentable_type}."
      )
    end
  end
    
end

