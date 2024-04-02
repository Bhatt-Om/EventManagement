class AddDistanceToVolunteerPresences < ActiveRecord::Migration[7.1]
  def change
    add_column :volunteer_presences, :distance, :string, default: '0'
    add_column :volunteer_presences, :volunteer_lat, :float, default: 0.0
    add_column :volunteer_presences, :volunteer_lon, :float, default: 0.0
  end
end
