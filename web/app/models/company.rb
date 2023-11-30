class Company < ApplicationRecord
  belongs_to :user
  has_rich_text :description
  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  
  has_many :comments, as: :commentable, dependent: :destroy

  # Validation
  validates :name, :contact, :address, :phone, :about, :category, presence: true
  validates :name, :email, uniqueness: true
  #validates :phone, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 



  # Limit number of images to 4 for listings
  #validate :validate_image_count

  def validate_image_count
    return if content.blank?

    max_images = 4 # Set your limit here
    
    begin
      image_count = Nokogiri::HTML(content.body.to_trix_html).css('figure').size

      if image_count > max_images
        errors.add(:content, "can have at most #{max_images} images")
      end
    rescue => e
      errors.add(:content, "contains invalid HTML content")
    end
  end


  scope :in_category, ->(category) { where(category: category) if category.present? }
# ex usage: Company.in_category("technology")


    # Enum for Category
    # ex. Company.category
enum category: {
  agriculture: 'Agriculture',
  artisans_and_crafts: 'Artisans and Crafts',
  automotive: 'Automotive',
  beauty_and_home: 'Beauty & Home',
  business_services: 'Business Services',
  electrical: 'Contractor - Electrical',
  gc: 'Contractor - General',
  hvac: 'Contractor - HVAC',
  contractor_other: 'Contractor - Other',
  plumbing: 'Contractor - Plumbing',
  maintenance_and_repair: 'Maintenance & Repair',
  consultancies: 'Consultancies',
  consumer_goods_and_services: 'Consumer Goods & Services',
  events_and_festivals: 'Events and Festivals',
  health_and_wellness: 'Health & Wellness',
  industrial_goods_and_services: 'Industrial Goods & Services',
  other: 'Other',
  outdoor_and_sporting: 'Outdoor and Sporting',
  real_estate: 'Real Estate',
  restaurants_and_bars: 'Restaurants & Bars',
  transportation: 'Transportation',
}





  def self.ransackable_attributes(auth_object = nil)
    ["about", "address", "category", "contact", "email", "hours", "id", "name", "phone", "website"]
  end
end
