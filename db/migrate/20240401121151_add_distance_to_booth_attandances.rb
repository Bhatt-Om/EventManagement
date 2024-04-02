class AddDistanceToBoothAttandances < ActiveRecord::Migration[7.1]
  def change
    add_column :booth_attandances, :distance, :string, default: '0'
  end
end
