class Advert < ApplicationRecord
    belongs_to :campaign

    enum status: { active: 0, paused: 1, archived: 2 }
end
  