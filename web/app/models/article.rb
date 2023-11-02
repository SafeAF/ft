class Article < ApplicationRecord
  belongs_to :user

  has_many :comments, as: :commentable
  has_rich_text :content
  
  has_one_attached :thumbnail  do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end


  # Limit number of images to 5 for listings
  # validate :validate_image_count

  # def validate_image_count
  #   max_images = 4 # Set your limit here
  #   image_count = Nokogiri::HTML(content.body.to_trix_html).css('figure').size

  #   if image_count > max_images
  #     errors.add(:content, "can have at most #{max_images} images")
  #   end
  # end

  after_create :create_notifications_for_followers

  private

  def create_notifications_for_followers
    user.followers.each do |follower|
      Notification.create(
        user: follower,
        notifiable: self,
        status: :unread,
        message: "#{user.username} has published a new article: #{title.truncate(30)}."
      )
    end
  end
end
