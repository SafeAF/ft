class AddFlagsCountToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :flags_count, :integer, default: 0
  end
end
