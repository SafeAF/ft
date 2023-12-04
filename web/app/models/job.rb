class Job < ApplicationRecord
  belongs_to :user

  has_rich_text :details

  has_many :comments, as: :commentable

  
    validates :title, :description, presence: true
  #   # Validations for presence
  #   validates :title, :description, :job_type, :location, :company_name, :company_description, :company_website, :company_phone, :company_email, :company_contact, presence: true
    
  #   # Length validations
  #   validates :title, :job_type, :location, :company_name, length: { minimum: 1, maximum: 100 }
  #   validates :description, :company_description, length: { minimum: 10, maximum: 500 }
     validates :company_website, length: { maximum: 255 }
    
  #   # Format validations
     validates :company_email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" }
     validates :company_website, format: { with: /\Ahttps?:\/\/[\S]+\z/, message: "must be a valid URL starting with http:// or https://" }
    
  #   # Custom validation for phone format, allowing international formats
     validates :company_phone, format: { with: /\A\+?[\d\s\-()]+\z/, message: "is not a valid phone number" }
  
  #   # Only alphanumeric, spaces, and commas are allowed in the location field
     validates :location, format: { with: /\A[\w\s,]+\z/, message: "only allows alphanumeric characters, spaces, and commas" }
      
  #   # Custom validator for company contact name to allow only letters and basic punctuation
     validates :company_contact, format: { with: /\A[\p{Alpha}\p{Space}\-,.']+\z/, message: "only allows letters, spaces, and basic punctuation (hyphen, comma, period, apostrophe)" }
    
  #   # Validation for user_id to ensure the job is associated with a user
     validates :user_id, presence: true
  
  

  # # Limit number of images to 5 for listings
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
