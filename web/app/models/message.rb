class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  has_many :notifications, as: :notifiable, dependent: :destroy


  validates_presence_of :content, :conversation_id, :user_id

  
  def recipient
    if self.user_id == self.conversation.sender_id
      User.find(self.conversation.recipient_id)
    else
      User.find(self.conversation.sender_id)
    end
  end

  # Callback to create a notification after a message is saved
  after_create :create_notification

  def create_notification
    # Assuming the `recipient` method returns the user who is supposed to receive the message
    recipient = self.recipient
  
    if recipient && self.user != recipient
      Notification.create(
        user: recipient,  # Note that the notification now targets the recipient, not the sender
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

