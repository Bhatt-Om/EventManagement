class AddDistanceToVolunteerPresences < ActiveRecord::Migration[7.1]
  def change
    add_column :volunteer_presences, :distance, :string, default: '0'
    add_column :volunteer_presences, :volunteer_lat, :string, default: '0'
    add_column :volunteer_presences, :volunteer_lon, :string, default: '0'
  end
end
