class AddPinnedToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :pinned, :boolean, default: false
  end
end
