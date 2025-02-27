# db/seeds.rb
require_relative 'seeds/users'
require_relative 'seeds/adventures'
require_relative 'seeds/locations'
require_relative 'seeds/equipment'
require_relative 'seeds/locations_adventures'
require_relative 'seeds/travel_plans'
require_relative 'seeds/skills'

puts "Cleaning database..."
[TravelPlanEquipment, TravelPlansAdventure, TravelPlansLocation, LocationEquipment, AdventureEquipment, TravelPlan, LocationsAdventure, Equipment, Adventure, Location, User, Skill].each(&:destroy_all)

puts "Creating seeds..."
create_users
create_adventures
create_locations
create_equipment        # creates the equipment and associations
create_locations_adventures
create_travel_plans
create_skills

puts "Created #{User.count} users"
puts "Created #{Equipment.count} equipment"
puts "Created #{Adventure.count} adventures"
puts "Created #{Location.count} locations"
puts "Created #{LocationsAdventure.count} location-adventure connections"
puts "Created #{TravelPlan.count} travel plans"
puts "Created #{AdventureEquipment.count} adventure-equipment connections"
puts "Created #{LocationEquipment.count} location-equipment connections"
puts "Created #{Skill.count} skills"
