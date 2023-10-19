class Advertiser < ApplicationRecord
    has_many :campaigns, dependent: :destroy
end