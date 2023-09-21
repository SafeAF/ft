class Job < ApplicationRecord
  belongs_to :user

  has_rich_text :details

  has_many :comments, as: :commentable
end
