class User < ApplicationRecord
  before_validation :downcase_username

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

# Username validations
  validates :username,
    presence: true,
    length: { minimum: 5, maximum: 20 },
    exclusion: { in: %w(admin root guest superuser moderator), message: "is reserved." },
    uniqueness: { case_sensitive: false },
    format: { with: /\A[a-zA-Z0-9_-]+\z/, message: "only allows alphanumeric characters, underscores, and dashes" }


  # Ensure email is present, unique, and formatted correctly
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }


  # Ensure location is not too long and only contains valid characters if provided
  validates :location, length: { maximum: 100 },
            format: { with: /\A[a-zA-Z0-9 ,.]+\z/, message: 'only allows letters, numbers, commas, periods, and spaces' },
            allow_blank: true

  # Ensure that the flagged_count is an integer and greater than or equal to 0 if provided
  #validates :flagged_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  


  

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

  validate :validate_image_count

  def validate_image_count
    return if bio.blank? # Skip validation if bio is nil or empty
  
    max_images = 2 # Set your limit here
    begin
      # Attempt to parse the HTML and count <figure> tags (assuming images are wrapped in these)
      image_count = Nokogiri::HTML(bio.to_s).css('figure').size
  
      if image_count > max_images
        errors.add(:bio, "can have at most #{max_images} images")
      end
    rescue => e
      errors.add(:bio, "contains invalid HTML content") # Generic error if parsing fails
    end
  end
  


  # User Profile Picture
  has_one_attached :avatar  
  validate :avatar_format

    validates :avatar, content_type: [:png, :jpg, :jpeg, :webp, :gif]
  

  # Achievement Badges
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges

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

  # User searching

  def self.ransackable_attributes(auth_object = nil)
    ["username", "email"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Top Users, Featured Users, Default display

  scope :top_followed, -> { order(followers_count: :desc).limit(10) }
  scope :most_poasts, -> { joins(:poasts).group('users.id').order('COUNT(poasts.id) DESC').limit(10) }
  # Featured is not implemented yet
  scope :featured, -> { where(featured: true).limit(10) }

  def self.default_search
    # Fetch top followed and top poasters
    top_followed_users = top_followed.to_a
    most_poasts_users = most_poasts.to_a
  
    # Combine and remove duplicates
    combined_users = (top_followed_users + most_poasts_users).uniq
  
    # Fetch all other users and append them
    other_users = User.where.not(id: combined_users.map(&:id)).to_a
  
    # Combine all groups of users and ensure uniqueness
    all_users = (combined_users + other_users).uniq
  
    # Return the combined array
    all_users
  end
  
    

  # Timeline

  # def timeline_poasts
  #   followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
  #   Poast.where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: id)
  # end

  # Active Record version
  # Does not include users own poasts
  def timeline_poasts
    followed_user_ids = Relationship.where(follower_id: id).pluck(:followed_id)
    Poast.where(user_id: followed_user_ids)
  end
  
  # Include users own poasts  
  # def timeline_poasts
  #   followed_user_ids = Relationship.where(follower_id: id).pluck(:followed_id)
  #   followed_user_ids << id # Add the user's own ID to the list
  #   Poast.where(user_id: followed_user_ids)
  # end


  # Get the top followed users who the user isn't already following for the timeline
  # Order clause is borken in production?
  # scope :who_to_follow, -> (current_user) do
  #   where.not(id: current_user.following.pluck(:id) + [current_user.id])  # Exclude users the current user is already following, as well as themselves
  #   .order(followers_count: :desc)
  #   .limit(10)
  # end

  scope :who_to_follow, -> (current_user) do
    where.not(id: current_user.following.pluck(:id) + [current_user.id])  # Exclude users the current user is already following, as well as themselves
    .limit(10)
  end



  # Username slugs

  def to_param
    username
  end

  private
  
  def downcase_username
    username.downcase! if username.present?
  end


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


