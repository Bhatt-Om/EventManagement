class CreateBooths < ActiveRecord::Migration[7.1]
  def change
    create_table :booths do |t|
      t.references :user, null: true, foreign_key: false
      t.string :booth_name
      t.string :booth_number
      t.float :booth_lat
      t.float :booth_lon

      t.timestamps
    end
  end
end
