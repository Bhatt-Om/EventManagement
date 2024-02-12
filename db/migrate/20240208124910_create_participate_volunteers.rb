class CreateParticipateVolunteers < ActiveRecord::Migration[7.1]
  def change
    create_table :participate_volunteers do |t|
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :participate_request, default: 0

      t.timestamps
    end
  end
end
