class Advert < ApplicationRecord
    belongs_to :campaign

    has_one_attached :image

    enum status: { active: 0, paused: 1, archived: 2 }
end
  