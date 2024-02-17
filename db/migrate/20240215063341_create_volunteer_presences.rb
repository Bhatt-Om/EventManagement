class CreateVolunteerPresences < ActiveRecord::Migration[7.1]
  def change
    create_table :volunteer_presences do |t|
      t.references :participate_volunteer, null: false, foreign_key: true
      t.integer :request_type, default: 0
      t.integer :requst_status, default: 0
      t.string :date
      t.string :time
      t.string :location

      t.timestamps
    end
  end
end
