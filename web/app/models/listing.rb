class Listing < ApplicationRecord

  belongs_to :user

  has_rich_text :content

  validates :title, length: {maximum: 70}, allow_blank: false



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


  def self.ransackable_attributes(auth_object = nil)
    ["title", "category", "description", "location"]
  end
  end