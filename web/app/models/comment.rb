class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :replies, dependent: :destroy  
  has_many :flags, as: :flaggable, dependent: :destroy
end
