# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Users
user1 = User.create(email: 'user1@example.com', pw: 'password')
user2 = User.create(email: 'user2@example.com', pw: 'password')

# Locations: Real places in Japan
# Campsite Locations
mount_fuji_campsite = Location.create(name: 'Mount Fuji Campsite', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'A popular campsite located at the base of Mount Fuji with breathtaking views of the mountain.')
nikko_campsite = Location.create(name: 'Nikko National Park', city: 'Nikko', prefecture: 'Tochigi', details: 'Beautiful campsite surrounded by lush forests and waterfalls.')

# Hiking Locations
hakone_hiking = Location.create(name: 'Hakone Hiking Trails', city: 'Hakone', prefecture: 'Kanagawa', details: 'Famous hiking trails around Mount Hakone, known for its hot springs and scenic views.')
kamigamo_hiking = Location.create(name: 'Kamigamo Hiking Trails', city: 'Kyoto', prefecture: 'Kyoto', details: 'Popular hiking trails that lead to shrines and temples in the historic city of Kyoto.')

# Rock Climbing Locations
iwate_rock_climbing = Location.create(name: 'Iwate Rock Climbing', city: 'Iwate', prefecture: 'Iwate', details: 'A well-known climbing area offering a variety of routes with amazing views.')
yamanashi_rock_climbing = Location.create(name: 'Yamanashi Rock Climbing', city: 'Kofu', prefecture: 'Yamanashi', details: 'Offers some of the best rock climbing routes in the Yamanashi prefecture with stunning mountain views.')

# Adventures
camping = Adventure.create(name: 'Camping', details: 'Enjoy the wilderness by setting up camp at the base of a mountain or in a national park.', id_location: mount_fuji_campsite.id)
hiking = Adventure.create(name: 'Hiking', details: 'Explore the breathtaking hiking trails around Japan’s most famous mountains.', id_location: hakone_hiking.id)
rock_climbing = Adventure.create(name: 'Rock Climbing', details: 'Challenge yourself with rock climbing routes in some of Japan’s best climbing spots.', id_location: iwate_rock_climbing.id)

# Skills
fire_skill = Skill.create(title: 'Start a Fire', content: 'How to build a fire with sticks and flint.', video: 'video_link_here', image: 'image_link_here')
tent_skill = Skill.create(title: 'Pitch a Tent', content: 'Step-by-step guide to pitching a tent.', video: 'video_link_here', image: 'image_link_here')
climbing_skill = Skill.create(title: 'Rock Climbing', content: 'Essential tips for rock climbing and bouldering.', video: 'video_link_here', image: 'image_link_here')

# Adventure Skills
AdventureSkill.create(id_adventures: camping.id, id_skills: fire_skill.id)
AdventureSkill.create(id_adventures: hiking.id, id_skills: tent_skill.id)
AdventureSkill.create(id_adventures: rock_climbing.id, id_skills: climbing_skill.id)

# Travel Plans
travel_plan1 = TravelPlan.create(id_users: user1.id, title: 'Mount Fuji Camping Trip', content: 'Camping trip at the base of Mount Fuji with breathtaking views.', status: 'Active', id_locations: mount_fuji_campsite.id, id_adventures: camping.id)
travel_plan2 = TravelPlan.create(id_users: user2.id, title: 'Hakone Hiking Adventure', content: 'Explore the hiking trails around Mount Hakone.', status: 'Active', id_locations: hakone_hiking.id, id_adventures: hiking.id)
travel_plan3 = TravelPlan.create(id_users: user1.id, title: 'Rock Climbing in Iwate', content: 'Challenge yourself with rock climbing in Iwate.', status: 'Active', id_locations: iwate_rock_climbing.id, id_adventures: rock_climbing.id)
