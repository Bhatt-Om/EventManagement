class CreateBoothAttandances < ActiveRecord::Migration[7.1]
  def change
    create_table :booth_attandances do |t|
      t.references :booth, null: false, foreign_key: true
      t.string :date
      t.string :time
      t.float :user_lat, default: 0
      t.float :user_lot, default: 0
      t.integer :request_stats, default: 0
      t.integer :request_type, null: false
      
      t.timestamps
    end
  end
end
