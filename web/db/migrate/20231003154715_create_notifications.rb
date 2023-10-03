class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end

    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end
