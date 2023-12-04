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
    fresh_produce: 'Fresh Produce',
    rehoming: 'Re-homing',
    homemade_goods: 'Homemade Goods',
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
    other: 'Other',
    free: 'Free',
    iso: "ISO"
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