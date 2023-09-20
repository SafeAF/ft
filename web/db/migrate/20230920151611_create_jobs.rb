class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.string :job_type
      t.string :location
      t.string :company_name
      t.text :company_description
      t.string :company_website
      t.string :company_phone
      t.string :company_email
      t.string :company_contact
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
