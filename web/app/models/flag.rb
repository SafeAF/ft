class Flag < ApplicationRecord
  belongs_to :user
  belongs_to :flaggable, polymorphic: true
end
