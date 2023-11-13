class Conversation < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  

  # Validations
  validates :sender_id, presence: true
  validates :recipient_id, presence: true
  validate :sender_and_recipient_are_different


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

  # Order by conversations with the most recent message
  def self.ordered_by_recent_message_for(user, page = 1, per_page = 10)
    joins(:messages)
    .select('conversations.*, MAX(messages.created_at) as last_message_time')
    .where('conversations.id IN (?)', involving(user).ids)
    .group('conversations.id')
    .order('last_message_time DESC')
    .page(page)
    .per(per_page)
  end


  # # Improved method for order by recent message
  # def self.ordered_by_recent_message_for(user)
  #   Conversation.joins(:messages)
  #               .where(conversations: { id: Conversation.involving(user) })
  #               .select('conversations.*, MAX(messages.created_at) as last_message_time')
  #               .group('conversations.id')
  #               .order('last_message_time DESC')
  # end

  private

  def sender_and_recipient_are_different
    errors.add(:recipient_id, "can't be the same as sender") if sender_id == recipient_id
  end


end



