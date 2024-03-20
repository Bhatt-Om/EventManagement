# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create!(
    name: 'task managemnet',
    redirect_uri: '',
    scopes: ''
  )
end

if !Role.where(role_name: 'admin').any?
  Role.create!(role_name: 'admin')
  Role.create!(role_name: 'volunteer')
  User.create!(email: 'admin@email.com', password: '123456', role_id: Role.find_by(role_name: 'admin').id)
end

if Rails.env.development? && !Task.any?
  5.times { |num| Task.create!(event_name: "Event #{num}",other_instruction: 'thank you for joining', event_location: 'location', google_link: 'link', date: Date.today.strftime("%d/%m/%Y"), time: Time.now.strftime('%H:%M:%S'), points: '100')}
end