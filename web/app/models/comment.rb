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
      Notification.create(
        user: owner,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} commented on your #{self.commentable.class.name.downcase}."
      )
    end
  end
  
end

