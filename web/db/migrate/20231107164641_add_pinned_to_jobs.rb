class AddPinnedToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :pinned, :boolean, default: false
  end
end
