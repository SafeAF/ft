class Company < ApplicationRecord
    belongs_to :user

    has_rich_text :description

    has_one_attached :logo do |attachable|
        attachable.variant :thumb, resize_to_limit: [100, 100]
      end


    def self.ransackable_attributes(auth_object = nil)
      ["about", "address", "category", "contact", "created_at", "email", "hours", "id", "name", "phone", "updated_at", "user_id", "website"]
    end
end
