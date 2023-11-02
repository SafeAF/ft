class Poast < ApplicationRecord
  belongs_to :user
  has_one_attached :thumbnail
  has_rich_text :content

  has_many :comments, as: :commentable

  validates :title, presence: true
  validates :subheading, presence: true
  #validates :content, presence: true
  #validates :thumbnail, presence: true 
  


  # Limit number of images to 5 for listings
  #validate :validate_image_count

  def validate_image_count
    max_images = 2 # Set your limit here
    image_count = Nokogiri::HTML(content.body.to_trix_html).css('figure').size

    if image_count > max_images
      errors.add(:content, "can have at most #{max_images} images")
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

