class AddAdTypeToAdverts < ActiveRecord::Migration[7.0]
  def change
    add_column :adverts, :ad_type, :string
  end
end
