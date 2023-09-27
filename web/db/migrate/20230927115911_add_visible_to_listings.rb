class AddVisibleToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :visible, :boolean, default: true
  end
end
