class Job < ApplicationRecord
  belongs_to :user

  has_rich_text :details

  has_many :comments, as: :commentable

  def self.ransackable_attributes(auth_object = nil)
    ["company_contact", "company_description", "company_email", "company_name", "company_phone", "company_website",
     "description", "job_type", "location", "title"]
  end
end
