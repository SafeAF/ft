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
  agricultural_equipment_and_supplies: 'Agricultural Equipment and Supplies',
  antiques: 'Antiques and Collectables',
  apparel_and_accessories: 'Apparel & Accessories',
  artisans_and_crafts: 'Local Artisans and Crafts',
  automotive: 'Automotive',
  banking_and_finance: 'Banking & Finance',
  beauty_and_care: 'Beauty & Personal Care',
  business_services: 'Business Services',
  child_care: 'Child Care & Daycare Services',
  communications: 'Communications',
  concrete: 'Contractor - Concrete',
  demo: 'Contractor - Demolition',
  drywall: 'Contractor - Drywall',
  electrical: 'Contractor - Electrical',
  fencing: 'Contractor - Fencing',
  flooring: 'Contractor - Flooring',
  framing: 'Contractor - Framing',
  gc: 'Contractor - General',
  hvac: 'Contractor - HVAC',
  landscaping: 'Contractor - Landscaping',
  masonry: 'Contractor - Masonry',
  painting: 'Contractor - Painting',
  plumbing: 'Contractor - Plumbing',
  remodel: 'Contractor - Remodeling',
  roofing: 'Contractor - Roofing',
  siding: 'Contractor - Siding',
  construction_and_maintenance: 'Construction & Maintenance',
  consultancies: 'Consultancies',
  consumer_goods_and_services: 'Consumer Goods & Services',
  education: 'Education',
  energy_and_environment: 'Energy & Environment',
  equestrian_services: 'Equestrian Services',
  events_and_festivals: 'Events and Festivals',
  fabrication_and_welding: 'Fabrication & Welding',
  feed_stores: 'Feed Stores',
  gardening_and_landscaping_supplies: 'Gardening and Landscaping Supplies',
  hardware_and_home_improvement: 'Hardware & Home Improvement',
  health_and_wellness: 'Health & Wellness',
  home_decor: 'Home Decor & Interior Design',
  hospitality_and_tourism: 'Hospitality & Tourism',
  hunting_and_fishing_guides: 'Hunting and Fishing Guides',
  industrial_goods_and_services: 'Industrial Goods & Services',
  information_technology: 'Information Technology',
  insurance: 'Insurance',
  legal_and_compliance: 'Legal & Compliance',
  manufacturing: 'Manufacturing',
  media_and_entertainment: 'Media & Entertainment',
  non_profit: 'Non-Profit',
  other: 'Other',
  outdoor_and_sporting_goods: 'Outdoor and Sporting Goods',
  pharmacies_and_drug_stores: 'Pharmicies & Drug Stores',
  produce_and_farmers_markets: 'Produce and Farmers Markets',
  real_estate: 'Real Estate',
  restaurants: 'Restaurants',
  retail_and_ecommerce: 'Retail & E-commerce',
  senior_care: 'Senior Care & Services',
  shipping_and_logistics: 'Shipping & Logistics',
  snow_removal_services: 'Snow Removal Services',
  specialty_food_stores: 'Specialty Food Stores',
  telecommunications: 'Telecommunications',
  transportation: 'Transportation',
  veterinary_services: 'Veterinary Services',
  wineries_and_breweries: 'Wineries and Breweries'
}





  def self.ransackable_attributes(auth_object = nil)
    ["about", "address", "category", "contact", "email", "hours", "id", "name", "phone", "website"]
  end
end
