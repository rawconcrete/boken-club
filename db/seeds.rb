# Clear existing data first
TravelPlan.destroy_all
Adventure.destroy_all
Location.destroy_all
User.destroy_all

# Users
user1 = User.create!(email: 'user1@example.com', password: 'password')
user2 = User.create!(email: 'user2@example.com', password: 'password')

# Locations: Real places in Japan
# Campsite Locations
mount_fuji_campsite = Location.create!(name: 'Mount Fuji Campsite', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'A popular campsite located at the base of Mount Fuji with breathtaking views of the mountain.', activity_name: 'Camping')
nikko_campsite = Location.create!(name: 'Nikko National Park', city: 'Nikko', prefecture: 'Tochigi', details: 'Beautiful campsite surrounded by lush forests and waterfalls.', activity_name: 'Camping')

# Hiking Locations
hakone_hiking = Location.create!(name: 'Hakone Hiking Trails', city: 'Hakone', prefecture: 'Kanagawa', details: 'Famous hiking trails around Mount Hakone, known for its hot springs and scenic views.', activity_name: 'Hiking')
kamigamo_hiking = Location.create!(name: 'Kamigamo Hiking Trails', city: 'Kyoto', prefecture: 'Kyoto', details: 'Popular hiking trails that lead to shrines and temples in the historic city of Kyoto.', activity_name: 'Hiking')

# Rock Climbing Locations
iwate_rock_climbing = Location.create!(name: 'Iwate Rock Climbing', city: 'Iwate', prefecture: 'Iwate', details: 'A well-known climbing area offering a variety of routes with amazing views.', activity_name: 'Rock Climbing')
yamanashi_rock_climbing = Location.create!(name: 'Yamanashi Rock Climbing', city: 'Kofu', prefecture: 'Yamanashi', details: 'Offers some of the best rock climbing routes in the Yamanashi prefecture with stunning mountain views.', activity_name: 'Rock Climbing')

# Adventures
camping = Adventure.create!(name: 'Camping', details: 'Enjoy the wilderness by setting up camp at the base of a mountain or in a national park.', location_id: mount_fuji_campsite.id)
hiking = Adventure.create!(name: 'Hiking', details: 'Explore the breathtaking hiking trails around Japan's most famous mountains.', location_id: hakone_hiking.id)
rock_climbing = Adventure.create!(name: 'Rock Climbing', details: 'Challenge yourself with rock climbing routes in some of Japan's best climbing spots.', location_id: iwate_rock_climbing.id)

# Travel Plans - Changed status from 'Active' to 'pending'
travel_plan1 = TravelPlan.create!(user_id: user1.id, title: 'Mount Fuji Camping Trip', content: 'Camping trip at the base of Mount Fuji with breathtaking views.', status: 'pending', location_id: mount_fuji_campsite.id, adventure_id: camping.id)
travel_plan2 = TravelPlan.create!(user_id: user2.id, title: 'Hakone Hiking Adventure', content: 'Explore the hiking trails around Mount Hakone.', status: 'pending', location_id: hakone_hiking.id, adventure_id: hiking.id)
travel_plan3 = TravelPlan.create!(user_id: user1.id, title: 'Rock Climbing in Iwate', content: 'Challenge yourself with rock climbing in Iwate.', status: 'pending', location_id: iwate_rock_climbing.id, adventure_id: rock_climbing.id)

# Admin user seeds
admins = [
  { email: 'admin@admin.com', password: '123456', admin: true },
  { email: 'sarah@admin.com', password: '123456', admin: true },
  { email: 'nico@admin.com', password: '123456', admin: true },
  { email: 'lio@admin.com', password: '123456', admin: true }
]

admins.each do |admin_data|
  User.create!(admin_data)
end
