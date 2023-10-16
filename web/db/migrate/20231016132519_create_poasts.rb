class CreatePoasts < ActiveRecord::Migration[7.0]
  def change
    create_table :poasts do |t|
      t.string :title
      t.string :subheading
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
