class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Username validations
  validates :username,
  presence: true,
  length: { minimum: 3, maximum: 20 },
  exclusion: { in: %w(admin root guest superuser), message: "is reserved." },
  uniqueness: { case_sensitive: false },
  format: { with: /\A[a-zA-Z0-9]+\Z/, message: "only allows alphanumeric characters" }



  # Relationships
  has_many :companies, dependent: :destroy
  has_many :listings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :poasts, dependent: :destroy

  # Comments on user#show
  has_many :comments, as: :commentable, dependent: :destroy
  
  # ActiveText
  has_rich_text :bio

  # User Profile Picture
  has_one_attached :avatar  
  validate :avatar_format
  

  # Direct Messages
  has_many :sent_conversations, class_name: 'Conversation', foreign_key: :sender_id, dependent: :destroy
  has_many :received_conversations, class_name: 'Conversation', foreign_key: :recipient_id, dependent: :destroy

  has_many :messages, dependent: :destroy

  # For convenience, you might want to define a method to get all conversations for a user
  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", self.id, self.id)
  end


  # Follows
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end


  # Username slugs

  def to_param
    username
  end

  private
  
  # Format user profile picture
  def avatar_format
    return unless avatar.attached?

    if avatar.blob.content_type.start_with?('image/')
      if avatar.blob.byte_size > 10.megabytes
        errors.add(:avatar, 'size needs to be less than 10MB')
        avatar.purge
      end
    else
      avatar.purge
      errors.add(:avatar, 'needs to be an image')
    end
  end

end


