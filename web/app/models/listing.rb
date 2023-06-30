class Listing < ApplicationRecord

  belongs_to :user

  has_rich_text :content

  validates :title, length: {maximum: 70}, allow_blank: false



  has_one_attached :thumbnail  do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end


  end