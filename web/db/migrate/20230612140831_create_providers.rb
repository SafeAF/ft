class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :company
      t.string :contact
      t.string :address
      t.string :phone
      t.string :email
      t.string :website
      t.string :hours
      t.text :about
      t.string :category
      t.references :user, null: false, foreign_key: true
      t.timestamps
     

    end

  end
end
