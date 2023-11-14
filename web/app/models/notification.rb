class Notification < ApplicationRecord
    belongs_to :user
    belongs_to :notifiable, polymorphic: true
  
    enum status: { unread: 0, read: 1 }

    validates :user_id, :notifiable_type, :notifiable_id, :status, presence: true
    #validates :status, inclusion: { in: [0, 1] }
    #validates :status, inclusion: { in: statuses.keys } # If using enum for status
  
    # Custom validation for notifiable_type to ensure it's a valid type
    validate :validate_notifiable_type
  
    private
  
    def validate_notifiable_type
      valid_types = ['Comment', 'Poast', 'Message', 'Reply', 'Job', "Relationship", 'Listing', 'Article'] 
      unless valid_types.include?(notifiable_type)
        errors.add(:notifiable_type, 'is not a valid notifiable type')
      end
    end


end
  