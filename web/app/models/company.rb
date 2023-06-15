class Company < ApplicationRecord
  belongs_to :user
  has_rich_text :description
  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  
  # Validation
  validates :name, :contact, :address, :phone, :about, :category, presence: true
  validates :name, :email, uniqueness: true
  #validates :phone, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 


    # Enum for Category
    enum category: {
      agriculture: 'Agriculture',
      apparel_and_accessories: 'Apparel & Accessories',
      automotive: 'Automotive',
      aviation_and_aerospace: 'Aviation & Aerospace',
      banking_and_finance: 'Banking & Finance',
      biotechnology: 'Biotechnology',
      business_services: 'Business Services',
      chemicals: 'Chemicals',
      communications: 'Communications',
      construction_and_maintenance: 'Construction & Maintenance',
      consumer_goods_and_services: 'Consumer Goods & Services',
      education: 'Education',
      energy_and_environment: 'Energy & Environment',
      food_and_beverage: 'Food & Beverage',
      health_and_wellness: 'Health & Wellness',
      hospitality_and_tourism: 'Hospitality & Tourism',
      industrial_goods_and_services: 'Industrial Goods & Services',
      information_technology: 'Information Technology',
      insurance: 'Insurance',
      legal_and_compliance: 'Legal & Compliance',
      manufacturing: 'Manufacturing',
      media_and_entertainment: 'Media & Entertainment',
      non_profit: 'Non-Profit',
      pharmaceutical: 'Pharmaceutical',
      real_estate: 'Real Estate',
      retail_and_ecommerce: 'Retail & E-commerce',
      shipping_and_logistics: 'Shipping & Logistics',
      telecommunications: 'Telecommunications',
      textiles: 'Textiles',
      transportation: 'Transportation',
      utilities: 'Utilities',
      other: 'Other'
    }


    
  def self.ransackable_attributes(auth_object = nil)
    ["about", "address", "category", "contact", "email", "hours", "id", "name", "phone", "website"]
  end
end
