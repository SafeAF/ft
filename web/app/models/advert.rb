class Advert < ApplicationRecord
    belongs_to :campaign

    has_one_attached :image

    # validates :ad_type, inclusion: { in: %w[banner injection promoted],
    #     message: "%{value} is not a valid ad type" }


    def banner
        image.variant(resize_to_limit: [300, 100]).processed
    end
        

    def thumbnail
        image.variant(resize_to_limit: [50, 50]).processed
    end

    enum status: { active: 0, paused: 1, archived: 2 }
end
  

  