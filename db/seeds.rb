# db/seeds.rb
require_relative 'seeds/users'
require_relative 'seeds/adventures'
require_relative 'seeds/locations'
require_relative 'seeds/equipment'
require_relative 'seeds/locations_adventures'
require_relative 'seeds/travel_plans'
require_relative 'seeds/skills'
require_relative 'seeds/equipment_skills'
require_relative 'seeds/quizzes'

puts "Cleaning database..."
# Delete in the correct order to respect foreign key constraints
[QuizAnswer, QuizAttempt, Answer, Question, Quiz,
 TravelPlanEquipment, TravelPlanSkill, TravelPlansAdventure, TravelPlansLocation,
 TravelPlan, UserEquipment, LocationEquipment, AdventureEquipment, EquipmentSkill,
 Equipment, LocationsAdventure, LocationSkill, AdventureSkill, Skill, Adventure, Location, User].each do |model|
  if defined?(model)
    count = model.count
    model.destroy_all
    puts "Deleted #{count} #{model.name.pluralize}"
  else
    puts "Skipping #{model} as it's not defined"
  end
end

puts "Creating seeds..."
create_users
create_adventures
create_locations
create_equipment        # creates the equipment and associations
create_locations_adventures
create_travel_plans
create_skills
create_equipment_skills
create_quizzes

puts "Created #{User.count} users"
puts "Created #{Equipment.count} equipment"
puts "Created #{Adventure.count} adventures"
puts "Created #{Location.count} locations"
puts "Created #{LocationsAdventure.count} location-adventure connections"
puts "Created #{TravelPlan.count} travel plans"
puts "Created #{AdventureEquipment.count} adventure-equipment connections"
puts "Created #{LocationEquipment.count} location-equipment connections"
puts "Created #{Skill.count} skills"
puts "Created #{EquipmentSkill.count} equipment-skill connections"
puts "Created #{Quiz.count} quizzes"
puts "Created #{Question.count} questions"
puts "Created #{Answer.count} answers"
