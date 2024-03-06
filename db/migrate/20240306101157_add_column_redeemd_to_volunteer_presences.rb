class AddColumnRedeemdToVolunteerPresences < ActiveRecord::Migration[7.1]
  def change
    add_column :volunteer_presences, :redeemed_points, :boolean, default: false
  end
end
