class Listing < ApplicationRecord

  belongs_to :user

  has_rich_text :content
  has_many :comments, as: :commentable, dependent: :destroy

  
#  validates :title, length: {maximum: 70}, allow_blank: false

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :location, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true

  # Added this validation, crashed without it when bad filetype
  validates :thumbnail, content_type: [:png, :jpg, :jpeg, :webp, :gif]
  # Validate categories
  # validates :category, inclusion: { in: %w[Category1 Category2 Category3] }


  


  # Limit size of action_text
  #  validates :content, length: { maximum: 500.kilobytes }, if: -> { content.blob.present? }
  

  # Limit number of images to 5 for listings
   validate :validate_image_count

   def validate_image_count
    return if content.blank?

     max_images = 5 # Set your limit here
    begin
     image_count = Nokogiri::HTML(content.body.to_trix_html).css('figure').size
 
     if image_count > max_images
       errors.add(:content, "can have at most #{max_images} images")
     end
    rescue => e
      errors.add(:content, "contains invalid HTML content")
    end
   end
 

  has_one_attached :thumbnail  do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end


  enum category: {
    animal_products: 'Meat, Eggs, & Dairy',
    books_media: 'Books & Media',
    clothing: 'Clothing',
    crafts_art: 'Crafts & Art',
    electronics: 'Electronics',
    equipment: 'Equipment',
    free: 'Free',
    fresh_produce: 'Fresh Produce',
    furniture: 'Furniture',
    home_garden: 'Home & Garden',
    homemade_goods: 'Homemade Goods',
    iso: "ISO",
    other: 'Other',
    pets: 'Pets',
    rehoming: 'Re-homing',
    seeds_plants: 'Seeds & Plants',
    services: 'Services',
    sports_outdoors: 'Sports & Outdoors',
    tools: 'Tools',
    toys_games: 'Toys & Games',
    vehicles: 'Vehicles'
  }



    def self.ransackable_attributes(auth_object = nil)
      ["title", "category", "description", "location"]
    end

    after_create :create_notifications_for_followers

    private
  
    def create_notifications_for_followers
      # Notify followers about the new listing
      user.followers.each do |follower|
        Notification.create(
          user: follower,
          notifiable: self,
          status: :unread,
          message: "#{user.username} has posted a new listing: #{title.truncate(30)}."
        )
      end
    end
end