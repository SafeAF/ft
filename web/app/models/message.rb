class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  has_many :notifications, as: :notifiable, dependent: :destroy


  validates_presence_of :content, :conversation_id, :user_id

  
  # Callback to create a notification after a message is saved
  after_create :create_notification

  def create_notification
    if self.user
      Notification.create(
        user: self.user,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} sent you a private message."
      )
    end
  end

  def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end

end

