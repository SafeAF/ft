class AddVisibleToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :visible, :boolean, default: true
  end
end
