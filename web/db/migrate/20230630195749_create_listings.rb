class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table :listings do |t|
      t.string :title
      t.text :description
      t.string :location
      t.float :price
      t.integer :views

      t.timestamps
    end
  end
end
