class Advert < ApplicationRecord
    belongs_to :campaign

    has_one_attached :image

    def thumbnail
        image.variant(resize_to_limit: [50, 50]).processed
    end

    enum status: { active: 0, paused: 1, archived: 2 }
end
  