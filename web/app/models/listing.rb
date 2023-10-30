class Listing < ApplicationRecord

  belongs_to :user

  has_rich_text :content
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :flags, as: :flaggable, dependent: :destroy
  


  # Limit size of action_text
   # validates :content, length: { maximum: 500.kilobytes }, if: -> { content.blob.present? }
  

  # Limit number of images to 5 for listings
   validate :validate_image_count

   def validate_image_count
     max_images = 5 # Set your limit here
     image_count = Nokogiri::HTML(content.body.to_trix_html).css('figure').size
 
     if image_count > max_images
       errors.add(:content, "can have at most #{max_images} images")
     end
   end
 

  has_one_attached :thumbnail  do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end


  enum category: {
    fresh_produce: 'Fresh Produce',
    dairy_products: 'Dairy Products',
    meat_poultry: 'Meat & Poultry',
    grains: 'Grains',
    homemade_goods: 'Homemade Goods',
    farm_equipment: 'Farm Equipment',
    seeds_plants: 'Seeds & Plants',
    crafts_art: 'Crafts & Art',
    services: 'Services',
    vehicles: 'Vehicles',
    tools: 'Tools',
    equipment: 'Equipment',
    furniture: 'Furniture',
    electronics: 'Electronics',
    clothing: 'Clothing',
    home_garden: 'Home & Garden',
    books_media: 'Books & Media',
    sports_outdoors: 'Sports & Outdoors',
    toys_games: 'Toys & Games',
    pets: 'Pets',
    other: 'Other'
  }


  validates :title, length: {maximum: 70}, allow_blank: false


    def self.ransackable_attributes(auth_object = nil)
      ["title", "category", "description", "location"]
    end
  end