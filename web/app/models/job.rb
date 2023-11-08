class Job < ApplicationRecord
  belongs_to :user

  has_rich_text :details

  has_many :comments, as: :commentable



  # Limit number of images to 5 for listings
  validate :validate_image_count

  def validate_image_count
    return if details.blank?

      max_images = 4 # Set your limit here
    begin
      image_count = Nokogiri::HTML(details.body.to_trix_html).css('figure').size

      if image_count > max_images
        errors.add(:details, "can have at most #{max_images} images")
      end
    rescue => e
      errors.add(:bio, "contains invalid HTML content") # Generic error if parsing fails
    end
  end


  def self.ransackable_attributes(auth_object = nil)
    ["company_contact", "company_description", "company_email", "company_name", "company_phone", "company_website",
     "description", "job_type", "location", "title"]
  end

  after_create :create_notifications_for_followers

  private

  def create_notifications_for_followers
    user.followers.each do |follower|
      Notification.create(
        user: follower,
        notifiable: self,
        status: :unread,
        message: "#{user.username} has posted a new job."
      )
    end
  end
end
