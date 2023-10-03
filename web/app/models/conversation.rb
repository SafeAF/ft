class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  
  has_many :messages, dependent: :destroy


  def opposed_user(user)
    user == sender ? recipient : sender
  end

  scope :involving, -> (user) do
    where("sender_id = ? OR recipient_id = ?", user.id, user.id)
  end


  scope :between, -> (sender_id, recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?)",
     sender_id, recipient_id, recipient_id, sender_id)
  end



end
