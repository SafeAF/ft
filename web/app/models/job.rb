class Job < ApplicationRecord
  belongs_to :user

  has_rich_text :details

  has_many :comments, as: :commentable



  # Limit number of images to 5 for listings
  validate :validate_image_count

  def validate_image_count
    max_images = 4 # Set your limit here
    image_count = Nokogiri::HTML(content.body.to_trix_html).css('figure').size

    if image_count > max_images
      errors.add(:content, "can have at most #{max_images} images")
    end
  end


  def self.ransackable_attributes(auth_object = nil)
    ["company_contact", "company_description", "company_email", "company_name", "company_phone", "company_website",
     "description", "job_type", "location", "title"]
  end
end
