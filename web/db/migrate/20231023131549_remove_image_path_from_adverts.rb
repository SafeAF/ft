class RemoveImagePathFromAdverts < ActiveRecord::Migration[7.0]
  def change
      remove_column :adverts, :image_path, :string  
  end
end
