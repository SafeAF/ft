class CreateAdvertisers < ActiveRecord::Migration[7.0]
  def change
    create_table :advertisers do |t|

      t.string :name
      t.text :details
      t.string :status
      t.text :billing_info
      t.string :contact_name
      t.string :phone
      t.string :email
      

      t.timestamps
    end
  end
end
