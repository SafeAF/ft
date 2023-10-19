class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.integer :budget
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0 # using integer to store enum values
      t.references :advertiser, null: false, foreign_key: true


      t.timestamps
    end
  end
end
