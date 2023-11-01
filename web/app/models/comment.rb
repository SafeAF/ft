class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :replies, dependent: :destroy  
  has_many :flags, as: :flaggable, dependent: :destroy

  has_many :notifications, as: :notifiable, dependent: :destroy


  # Validations
  validates_length_of :content, minimum: 1, maximum: 3000, allow_blank: false,
    too_long: "Your comment cannot be more than 3000 characters.",
    too_short: "Your comment must contain at least one character."

  validates :flags_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :visible, inclusion: { in: [true, false] }


  # Callback to create a notification after a comment is saved
  after_create :create_notification

  def create_notification
    # Determine the owner of the commentable item
    owner = if self.commentable.respond_to?(:user)
              self.commentable.user
            elsif self.commentable.is_a?(User)
              self.commentable
            end
  
   return if owner == self.user # Skip notification if owner is the one who commented

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

