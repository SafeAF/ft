class Conversation < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  

#  validates_uniqueness_of :sender_id, scope: :recipient_id


  # scope in order to sort messages by created date
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy

  # get the last message sent to put in conversation index view
  def last_message
    last_msg = messages.last
    last_msg ? last_msg.content : "No messages yet."
  end


  # Get the other user in a conversation
  def opposed_user(user)
    user == sender ? recipient : sender
  end

  # Get the two users involved in a conversation
  scope :involving, -> (user) do
    where("sender_id = ? OR recipient_id = ?", user.id, user.id)
  end

  # Pull up the conversation between users
  scope :between, -> (sender_id, recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)",
     sender_id, recipient_id, recipient_id, sender_id)
  end



end



