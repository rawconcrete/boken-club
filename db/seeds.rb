# db/seeds.rb
require_relative 'seeds/users'
require_relative 'seeds/equipment'
require_relative 'seeds/adventures'
require_relative 'seeds/locations'
require_relative 'seeds/locations_adventures'
require_relative 'seeds/travel_plans'

puts "Cleaning database..."
[TravelPlan, LocationsAdventure, Adventure, Location, User, Equipment, TravelPlanEquipment, LocationEquipment, AdventureEquipment].each(&:destroy_all)

puts "Creating seeds..."
create_users
create_equipment
create_adventures
create_locations
create_locations_adventures
create_travel_plans

puts "Created #{User.count} users"
puts "Created #{Equipment.count} equipment"
puts "Created #{Adventure.count} adventures"
puts "Created #{Location.count} locations"
puts "Created #{LocationsAdventure.count} location-adventure connections"
puts "Created #{TravelPlan.count} travel plans"
