class AddFlagsCountToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :flags_count, :integer, default: 0
  end
end
