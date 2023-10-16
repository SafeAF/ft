class Poast < ApplicationRecord
  belongs_to :user
  has_one_attached :thumbnail
  has_rich_text :content

  validates :title, presence: true
  validates :subheading, presence: true
  #validates :content, presence: true
  #validates :thumbnail, presence: true 
  

  has_one_attached :thumbnail  do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end
end

