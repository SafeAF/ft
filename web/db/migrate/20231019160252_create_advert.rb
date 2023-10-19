class CreateAdvert < ActiveRecord::Migration[7.0]
  def change
    create_table :adverts do |t|
      t.string :name
      t.string :image_path
      t.string :alt_text
      t.string :link_url
      t.datetime :start_date
      t.datetime :end_date
      t.integer :click_count, default: 0
      t.integer :impressions, default: 0
      t.string :status
      t.string :position
      t.integer :prominence
      t.string :display_locations
      t.string :tags
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
