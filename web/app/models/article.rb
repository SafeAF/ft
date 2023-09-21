class Article < ApplicationRecord
  belongs_to :user

  has_many :comments, as: :commentable
  has_rich_text :content
  
  has_one_attached :thumbnail  do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end

end
