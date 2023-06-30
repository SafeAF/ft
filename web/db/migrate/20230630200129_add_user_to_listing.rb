class AddUserToListing < ActiveRecord::Migration[7.0]
  def change
    add_reference :listings, :user, null: false, foreign_key: true
  end
end
