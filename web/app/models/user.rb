class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # Validations
  validates :username, presence: true, uniqueness: true

  # Relationships
  has_many :companies, dependent: :destroy
  has_many :listings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :articles, dependent: :destroy
  

  has_rich_text :bio

  # Direct Messages
  has_many :sent_conversations, class_name: 'Conversation', foreign_key: :sender_id, dependent: :destroy
  has_many :received_conversations, class_name: 'Conversation', foreign_key: :recipient_id, dependent: :destroy

  has_many :messages, dependent: :destroy

  # For convenience, you might want to define a method to get all conversations for a user
  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", self.id, self.id)
  end



end
