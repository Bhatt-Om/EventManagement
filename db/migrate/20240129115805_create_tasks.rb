class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :event_name
      t.string :event_location
      t.string :google_link
      t.string :date
      t.string :time
      t.text :other_instruction
      t.string :points, default: 0

      t.timestamps
    end
  end
end
