class Poast < ApplicationRecord
  belongs_to :user
  has_one_attached :thumbnail
  has_rich_text :content

    validates :thumbnail, content_type: [:png, :jpg, :jpeg, :webp, :gif]

  has_many :comments, as: :commentable


  validates :title, presence: true, length: { minimum: 1, maximum: 100 }
  validates :subheading, presence: true, length: { minimum: 1, maximum: 200 }
  
  #validates :content, presence: true
  #validates :thumbnail, presence: true 
  


  # Limit number of images to 5 for listings
  validate :validate_image_count

  def validate_image_count
    return if content.blank?
    max_images = 2 # Set your limit here
    begin
      image_count = Nokogiri::HTML(content.body.to_trix_html).css('figure').size

      if image_count > max_images
        errors.add(:content, "can have at most #{max_images} images")
      end
    rescue => e
      errors.add(:bio, "contains invalid HTML content") # Generic error if parsing fails
    end
  end


  has_one_attached :thumbnail  do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end

  after_create :create_notifications_for_followers

  private

  def create_notifications_for_followers
    # Assuming 'followers' returns a collection of users who follow the author of the poast
    self.user.followers.each do |follower|
      Notification.create(
        user: follower,
        notifiable: self,
        status: :unread,
        message: "#{self.user.username} has made a new poast: #{title.truncate(30)}."
      )
    end
  end
end

