class AddPinnedToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :pinned, :boolean, default: false
  end
end
