# db/seeds.rb
[TravelPlan, LocationsAdventure, Adventure, Location, User].each(&:destroy_all)

# basic users
User.create!([
 {email: 'user1@example.com', password: 'password'},
 {email: 'user2@example.com', password: 'password'}
])

# core adventures
adventures = Adventure.create!([
 {
   name: 'Hiking',
   details: 'Explore Japan\'s diverse mountain trails and natural scenery',
   tips: 'Bring proper hiking boots and plenty of water',
   warnings: 'Check weather conditions and trail closures before departing'
 },
 {
   name: 'Rock Climbing',
   details: 'Scale Japan\'s world-class climbing spots',
   tips: 'Always climb with a partner and proper safety gear',
   warnings: 'Verify route conditions and your skill level matches'
 },
 {
   name: 'Camping',
   details: 'Experience overnight stays in Japan\'s wilderness',
   tips: 'Reserve campsites in advance during peak seasons',
   warnings: 'Store food properly to avoid wildlife encounters'
 }
])

# real locations
locations = Location.create!([
 {
   name: 'Mount Fuji Fujiyoshida 5th Station',
   city: 'Fujiyoshida',
   prefecture: 'Yamanashi',
   details: 'Popular starting point for Mount Fuji climbs with camping facilities',
   adventure_name: 'Hiking',
   tips: 'Best hiking season is July-August',
   warnings: 'Altitude sickness possible above 2400m'
 },
 {
   name: 'Ogawayama',
   city: 'Saku',
   prefecture: 'Nagano',
   details: 'Premier granite climbing area with multi-pitch routes',
   adventure_name: 'Rock Climbing',
   tips: 'Spring and fall offer best climbing conditions',
   warnings: 'Some routes require trad gear'
 },
 {
   name: 'Mount Takao',
   city: 'Hachioji',
   prefecture: 'Tokyo',
   details: 'Accessible mountain with multiple hiking trails',
   adventure_name: 'Hiking',
   tips: 'Trail 6 is least crowded',
   warnings: 'Very busy during autumn leaves season'
 },
 {
   name: 'Mitake Valley',
   city: 'Ome',
   prefecture: 'Tokyo',
   details: 'River-side bouldering and top-rope climbing area',
   adventure_name: 'Rock Climbing',
   tips: 'Good shade for summer climbing',
   warnings: 'Routes can be slippery after rain'
 },
 {
   name: 'Nagatoro',
   city: 'Nagatoro',
   prefecture: 'Saitama',
   details: 'Riverside climbing area with camping nearby',
   adventure_name: 'Rock Climbing',
   tips: 'Many beginner-friendly routes',
   warnings: 'Check river levels during rainy season'
 },
 {
   name: 'Lake Kawaguchiko',
   city: 'Fujikawaguchiko',
   prefecture: 'Yamanashi',
   details: 'Lakeside campsites with Mt. Fuji views',
   adventure_name: 'Camping',
   tips: 'Book ahead for sites with best Fuji views',
   warnings: 'High winds common in winter'
 }
])

# link locations to adventures
locations.each do |location|
 matching_adventure = adventures.find { |a| a.name == location.adventure_name }
 location.adventures << matching_adventure if matching_adventure
end

# travel plans
user1 = User.first
user2 = User.second

TravelPlan.create!([
 {
   user: user1,
   title: 'Weekend at Ogawayama',
   content: 'Multi-pitch climbing trip',
   status: 'pending',
   location: Location.find_by(name: 'Ogawayama'),
   adventure: Adventure.find_by(name: 'Rock Climbing')
 },
 {
   user: user2,
   title: 'Mount Takao Day Hike',
   content: 'Day trip hiking various trails',
   status: 'pending',
   location: Location.find_by(name: 'Mount Takao'),
   adventure: Adventure.find_by(name: 'Hiking')
 }
])

# admin/debugging accounts
[
 { email: 'admin@admin.com', password: '123456', admin: true },
 { email: 'sarah@admin.com', password: '123456', admin: true },
 { email: 'nico@admin.com', password: '123456', admin: true },
 { email: 'lio@admin.com', password: '123456', admin: true },
 { email: 'lio', password: '123', admin: true }
].each do |admin_data|
 user = User.new(admin_data)
 user.save(validate: false)
end
