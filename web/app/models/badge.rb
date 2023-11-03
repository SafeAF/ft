class Badge < ApplicationRecord
    has_many :user_badges, dependent: :destroy
    has_many :users, through: :user_badges

    #has_one_attached :image



  has_one_attached :image  do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end
    
  # has_one_attached :image  do |attachable|
  #   attachable.variant :thumbnail, resize_to_limit: [300, 300]
  # end
    
#   has_one_attached :image  do |attachable|
#     attachable.variant :thumbnail, resize_to_limit: [30, 30]
#   end
end
  