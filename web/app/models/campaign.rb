class Campaign < ApplicationRecord
    belongs_to :advertiser
    has_many :adverts, dependent: :destroy
  
    enum status: { inactive: 0, active: 1, completed: 2 }
end
  