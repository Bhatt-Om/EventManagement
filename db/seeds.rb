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
  User.create!(email: 'bhattom1001@gmail.com', password: '123456', role_id: Role.find_by(role_name: 'volunteer').id)
  User.create!(email: 'richamodi04@gmail.com', password: '123456', role_id: Role.find_by(role_name: 'volunteer').id)
  User.create!(email: 'voonnasaikirti22@gmail.com', password: '123456', role_id: Role.find_by(role_name: 'volunteer').id)
  User.create!(email: 'chesscobra05@gmail.com', password: '123456', role_id: Role.find_by(role_name: 'volunteer').id)
  User.create!(email: 'vaghelamaitulya85@gmail.com', password: '123456', role_id: Role.find_by(role_name: 'volunteer').id)
  User.create!(email: 'kenilsoni2710@gmail.com', password: '123456', role_id: Role.find_by(role_name: 'volunteer').id)
  User.create!(email: 'admin@email.com', password: '123456', role_id: Role.find_by(role_name: 'admin').id)
end

if Rails.env.development? && !Task.any?
  500.times { |num| Task.create!(event_name: "Event #{num + 1}",other_instruction: 'thank you for joining', event_location: 'location', google_link: 'link', date: Date.today.strftime("%d/%m/%Y"), time: Time.now.strftime('%H:%M:%S'), points: '100')}
end


if Rails.env.development? && !Booth.any?
  50.times { |num| Booth.create!(booth_name: "booth_name #{num + 1}",booth_number: "#{num+1}", booth_lat: (23.0 +"0.#{num +1 }".to_f).to_s, booth_lon: (72.0 +"0.#{num +1 }".to_f).to_s) }
end
