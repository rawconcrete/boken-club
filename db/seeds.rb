# db/seeds.rb
[TravelPlan, LocationsAdventure, Adventure, Location, User].each(&:destroy_all)

# core adventures
adventures = Adventure.create!([
  { name: 'Hiking', details: "Explore Japan's diverse mountain trails and natural scenery", tips: 'Bring proper hiking boots and plenty of water', warnings: 'Check weather conditions and trail closures before departing' },
  { name: 'Rock Climbing', details: "Scale Japan's world-class climbing spots", tips: 'Always climb with a partner and proper safety gear', warnings: 'Verify route conditions and ensure your skill level matches' },
  { name: 'Camping', details: "Experience overnight stays in Japan's wilderness", tips: 'Reserve campsites in advance during peak seasons', warnings: 'Store food properly to avoid wildlife encounters' },
  { name: 'Trekking', details: 'Long-distance walking through rugged terrain', tips: 'Prepare for multi-day hikes with proper gear', warnings: 'Requires endurance and careful planning' },
  { name: 'Kayaking', details: 'Paddle through scenic rivers, lakes, and coastal waters', tips: 'Check local regulations and wear a life vest', warnings: 'Be cautious of strong currents and changing tides' },
  { name: 'Caving', details: 'Explore underground caves and lava tubes', tips: 'Bring a helmet and headlamp', warnings: 'Watch out for slippery rocks and confined spaces' },
  { name: 'Snowshoeing', details: "Trek through Japan’s snowy landscapes in winter", tips: 'Wear waterproof boots and dress in layers', warnings: 'Check avalanche risk and weather conditions' },
  { name: 'Skiing & Snowboarding', details: "Enjoy Japan’s famous powder snow at top ski resorts", tips: 'Rent or bring high-quality gear for the best experience', warnings: 'Be aware of off-piste dangers and changing conditions' },
  { name: 'Wildlife Watching', details: "Observe Japan’s unique wildlife in its natural habitat", tips: 'Bring binoculars and move quietly to avoid disturbing animals', warnings: 'Maintain a safe distance and avoid feeding wildlife' },
  { name: 'Fishing', details: "Catch fish in Japan’s rivers, lakes, and coastal waters", tips: 'Obtain a fishing permit if required', warnings: 'Be aware of local fishing regulations and seasonal restrictions' },
  { name: 'Trail Running', details: "Run through scenic mountain trails and forests", tips: 'Wear trail running shoes with good grip', warnings: 'Be cautious of uneven terrain and wildlife encounters' },
  { name: 'Cycling', details: "Ride through Japan’s countryside and scenic coastal routes", tips: 'Check local cycling routes and bring repair tools', warnings: 'Watch out for traffic and road conditions' },
  { name: 'Paragliding', details: "Soar above Japan’s mountains and coastlines", tips: 'Book with a certified instructor if you’re a beginner', warnings: 'Be mindful of wind conditions and landing zones' },
  { name: 'Rafting', details: "Navigate Japan’s thrilling whitewater rapids", tips: 'Wear a helmet and life vest for safety', warnings: 'Only attempt advanced rapids with proper training' },
  { name: 'Diving', details: "Explore coral reefs and underwater caves in Japan’s seas", tips: 'Use a certified diving guide for the best spots', warnings: 'Be cautious of strong currents and marine life' },
  { name: 'Star Gazing', details: "Enjoy clear night skies from remote areas", tips: 'Bring a telescope or binoculars for a better view', warnings: 'Check weather conditions and avoid light pollution' }
])

# real locations
locations = Location.create!([
  { name: 'Mount Fuji Fujiyoshida 5th Station', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'Popular starting point for Mount Fuji climbs with camping facilities', adventure_name: 'Hiking', tips: 'Best hiking season is July-August', warnings: 'Altitude sickness possible above 2400m' },
  { name: 'Ogawayama', city: 'Saku', prefecture: 'Nagano', details: 'Premier granite climbing area with multi-pitch routes', adventure_name: 'Rock Climbing', tips: 'Spring and fall offer best climbing conditions', warnings: 'Some routes require trad gear' },
  { name: 'Mount Takao', city: 'Hachioji', prefecture: 'Tokyo', details: 'Accessible mountain with multiple hiking trails', adventure_name: 'Hiking', tips: 'Trail 6 is least crowded', warnings: 'Very busy during autumn leaves season' },
  { name: 'Mitake Valley', city: 'Ome', prefecture: 'Tokyo', details: 'River-side bouldering and top-rope climbing area', adventure_name: 'Rock Climbing', tips: 'Good shade for summer climbing', warnings: 'Routes can be slippery after rain' },
  { name: 'Nagatoro', city: 'Nagatoro', prefecture: 'Saitama', details: 'Riverside climbing area with camping nearby', adventure_name: 'Rock Climbing', tips: 'Many beginner-friendly routes', warnings: 'Check river levels during rainy season' },
  { name: 'Lake Kawaguchiko', city: 'Fujikawaguchiko', prefecture: 'Yamanashi', details: 'Lakeside campsites with Mt. Fuji views', adventure_name: 'Camping', tips: 'Book ahead for sites with best Fuji views', warnings: 'High winds common in winter' },
  { name: 'Shiretoko National Park', city: 'Shari', prefecture: 'Hokkaido', details: 'Unspoiled nature and scenic coastlines', adventure_name: 'Hiking', tips: 'Bear warnings in place, bring bells', warnings: 'Harsh winter conditions' },
  { name: 'Shirakami-Sanchi', city: 'Ajigasawa', prefecture: 'Aomori', details: 'UNESCO-listed beech forest trekking area', adventure_name: 'Trekking', tips: 'Great for birdwatching and multi-day treks', warnings: 'Limited accommodations nearby' },
  { name: 'Hachimantai', city: 'Hachimantai', prefecture: 'Iwate', details: 'Volcanic plateau with hot springs and scenic trails', adventure_name: 'Hiking', tips: 'Best visited in autumn for vibrant foliage', warnings: 'Snowfall can block trails in winter' },
  { name: 'Zao Mountain Range', city: 'Zao', prefecture: 'Miyagi', details: 'Famous for frost-covered trees and scenic hiking', adventure_name: 'Hiking', tips: 'Visit in winter for "snow monsters" or in summer for hiking', warnings: 'Cold conditions in winter' },
  { name: 'Mount Chokai', city: 'Nikaho', prefecture: 'Akita', details: 'Stratovolcano with panoramic coastal views', adventure_name: 'Hiking', tips: 'Bring windproof gear due to strong gusts', warnings: 'Rapid weather changes at summit' },
  { name: 'Mount Gassan', city: 'Tsuruoka', prefecture: 'Yamagata', details: 'Sacred peak with pilgrimage trails', adventure_name: 'Hiking', tips: 'Popular for spiritual hikes in summer', warnings: 'Deep snow until late spring' },
  { name: 'Oze National Park', city: 'Minamiaizu', prefecture: 'Fukushima', details: 'Expansive highland marshland', adventure_name: 'Trekking', tips: 'Great for summer wildflowers', warnings: 'Limited access in winter' },
  { name: 'Mount Tsukuba', city: 'Tsukuba', prefecture: 'Ibaraki', details: 'Double-peaked mountain with easy trails', adventure_name: 'Hiking', tips: 'Take the ropeway for scenic views', warnings: 'Can be crowded on weekends' },
  { name: 'Nikko National Park', city: 'Nikko', prefecture: 'Tochigi', details: 'UNESCO-listed park with waterfalls and lakes', adventure_name: 'Hiking', tips: 'Best visited in autumn for fall foliage', warnings: 'Heavy snowfall in winter' },
  { name: 'Mount Tanigawa', city: 'Minakami', prefecture: 'Gunma', details: 'Rocky mountain with challenging climbs', adventure_name: 'Hiking', tips: 'Take the ropeway for a head start', warnings: 'One of Japan’s most dangerous mountains' },
  { name: 'Chichibu-Tama-Kai National Park', city: 'Chichibu', prefecture: 'Saitama', details: 'Mountainous area with historical shrines', adventure_name: 'Hiking', tips: 'Best for day trips from Tokyo', warnings: 'Some trails require good navigation skills' },
  { name: 'Nokogiriyama', city: 'Futtsu', prefecture: 'Chiba', details: 'Steep mountain with a massive Buddha carving', adventure_name: 'Hiking', tips: 'Best on clear days for Tokyo Bay views', warnings: 'Steep steps require good fitness' },
  { name: 'Tanzawa Mountains', city: 'Atsugi', prefecture: 'Kanagawa', details: 'Rugged trails with scenic ridges', adventure_name: 'Hiking', tips: 'Pack enough water, as sources are limited', warnings: 'Can be challenging for beginners' },
  { name: 'Myoko-Togakushi Renzan National Park', city: 'Myoko', prefecture: 'Niigata', details: 'Mountainous area with lakes and ski resorts', adventure_name: 'Hiking', tips: 'Good in summer for hikes and winter for skiing', warnings: 'Variable weather conditions' },
  { name: 'Tateyama-Kurobe Alpine Route', city: 'Tateyama', prefecture: 'Toyama', details: 'Scenic route with Japan’s highest snowfall walls', adventure_name: 'Hiking', tips: 'Go in spring for snow walls, autumn for foliage', warnings: 'Cold at higher elevations' },
  { name: 'Mount Hakusan', city: 'Hakusan', prefecture: 'Ishikawa', details: 'Sacred mountain with alpine meadows', adventure_name: 'Trekking', tips: 'Best visited in summer', warnings: 'Trails are closed in winter' },
  { name: 'Tojinbo Cliffs', city: 'Sakai', prefecture: 'Fukui', details: 'Dramatic basalt sea cliffs', adventure_name: 'Hiking', tips: 'Visit at sunset for stunning views', warnings: 'Strong winds near the cliffs' },
  { name: 'Kamikochi', city: 'Matsumoto', prefecture: 'Nagano', details: 'Alpine valley with pristine landscapes', adventure_name: 'Trekking', tips: 'Best visited in autumn', warnings: 'Closed in winter' },
  { name: 'Mount Norikura', city: 'Takayama', prefecture: 'Gifu', details: 'Easily accessible high-altitude hiking', adventure_name: 'Hiking', tips: 'Take the shuttle bus for easier access', warnings: 'Weather can change suddenly' },
  { name: 'Korankei Gorge', city: 'Toyota', prefecture: 'Aichi', details: 'Famous for vibrant maple leaves', adventure_name: 'Hiking', tips: 'Best in autumn', warnings: 'Crowded during peak foliage season' },
  { name: 'Kumano Kodo', city: 'Tanabe', prefecture: 'Wakayama', details: 'UNESCO-listed pilgrimage trails', adventure_name: 'Trekking', tips: 'Ideal for multi-day spiritual journeys', warnings: 'Some routes are physically demanding' },
  { name: 'Mount Fuji', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'Japan’s highest peak with multiple climbing routes.', adventure_name: 'Hiking', tips: 'Best climbed in summer; reserve mountain huts in advance.', warnings: 'Altitude sickness is common above 2,400m.' },
  { name: 'Kamikochi', city: 'Matsumoto', prefecture: 'Nagano', details: 'Alpine valley with stunning scenery and well-maintained trails.', adventure_name: 'Hiking', tips: 'Best visited in autumn for the foliage.', warnings: 'Closed in winter due to heavy snowfall.' },
  { name: 'Daisetsuzan National Park', city: 'Kamikawa', prefecture: 'Hokkaido', details: 'Rugged terrain and active volcanoes with breathtaking views.', adventure_name: 'Hiking', tips: 'Bring proper gear for sudden weather changes.', warnings: 'Bear encounters are possible; carry bear spray.' },
  { name: 'Ogawayama', city: 'Saku', prefecture: 'Nagano', details: 'Japan’s premier granite climbing destination.', adventure_name: 'Rock Climbing', tips: 'Best climbing conditions in spring and fall.', warnings: 'Some routes require trad gear and advanced techniques.' },
  { name: 'Mitake Valley', city: 'Ome', prefecture: 'Tokyo', details: 'Popular for bouldering with scenic river views.', adventure_name: 'Rock Climbing', tips: 'Good shade for summer climbing.', warnings: 'Routes can be slippery after rain.' },
  { name: 'Gozaisho Ropeway', city: 'Komono', prefecture: 'Mie', details: 'Rock climbing destination with challenging routes.', adventure_name: 'Rock Climbing', tips: 'Check local climbing conditions before visiting.', warnings: 'Routes can be difficult; not beginner-friendly.' },
  { name: 'Lake Kawaguchiko', city: 'Fujikawaguchiko', prefecture: 'Yamanashi', details: 'Lakeside campsites with stunning views of Mount Fuji.', adventure_name: 'Camping', tips: 'Book ahead for the best spots with Fuji views.', warnings: 'Strong winds are common in winter.' },
  { name: 'Shiretoko National Park', city: 'Shari', prefecture: 'Hokkaido', details: 'Remote camping with unspoiled natural scenery.', adventure_name: 'Camping', tips: 'Bear-proof your food and carry proper gear.', warnings: 'Harsh winter conditions make access difficult.' },
  { name: 'Oze National Park', city: 'Minamiaizu', prefecture: 'Fukushima', details: 'Expansive highland marshland with designated campsites.', adventure_name: 'Camping', tips: 'Ideal for summer hikes and overnight stays.', warnings: 'Limited access in winter.' },
  { name: 'Kumano Kodo', city: 'Tanabe', prefecture: 'Wakayama', details: 'UNESCO-listed pilgrimage trails with scenic views.', adventure_name: 'Trekking', tips: 'Ideal for multi-day spiritual journeys.', warnings: 'Some routes are physically demanding.' },
  { name: 'Yoshida Trail, Mount Fuji', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'The most popular route for ascending Mount Fuji.', adventure_name: 'Trekking', tips: 'Reserve a mountain hut for overnight stays.', warnings: 'Altitude sickness can be an issue.' },
  { name: 'Shirakami-Sanchi', city: 'Ajigasawa', prefecture: 'Aomori', details: 'UNESCO-listed beech forest trekking area.', adventure_name: 'Trekking', tips: 'Great for birdwatching and multi-day treks.', warnings: 'Limited accommodations nearby.' },
  { name: 'Shimanami Kaido', city: 'Onomichi', prefecture: 'Hiroshima', details: 'Island-hopping kayaking with scenic ocean views.', adventure_name: 'Kayaking', tips: 'Check tide charts for safe paddling conditions.', warnings: 'Be aware of strong currents and boat traffic.' },
  { name: 'Lake Biwa', city: 'Otsu', prefecture: 'Shiga', details: 'Japan’s largest freshwater lake, great for kayaking.', adventure_name: 'Kayaking', tips: 'Morning paddles offer the calmest waters.', warnings: 'Wind can pick up quickly in the afternoon.' },
  { name: 'Niyodo River', city: 'Niyodogawa', prefecture: 'Kochi', details: 'Crystal-clear waters famous for “Niyodo Blue.”', adventure_name: 'Kayaking', tips: 'Go in summer for the best experience.', warnings: 'Some rapids require intermediate paddling skills.' },
  { name: 'Akiyoshido Cave', city: 'Mine', prefecture: 'Yamaguchi', details: 'Japan’s largest limestone cave with underground rivers.', adventure_name: 'Caving', tips: 'Bring a headlamp and wear sturdy shoes.', warnings: 'Some sections can be slippery.' },
  { name: 'Ryusendo Cave', city: 'Iwaizumi', prefecture: 'Iwate', details: 'Deep limestone cave with stunning blue underground lakes.', adventure_name: 'Caving', tips: 'Join a guided tour for the best experience.', warnings: 'Cold temperatures inside; dress appropriately.' },
  { name: 'Taketomi Caves', city: 'Taketomi', prefecture: 'Okinawa', details: 'Tropical caves with unique limestone formations.', adventure_name: 'Caving', tips: 'Check for guided eco-tours.', warnings: 'Can be humid and narrow in some sections.' },
  { name: 'Mount Fuji Yoshida Trail', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'Most popular trail starting from the Subaru Line 5th Station, merging with Subashiri Trail near the 8th Station.', adventure_name: 'Hiking', tips: 'Numerous mountain huts; expect crowds. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Extremely crowded during peak season, especially weekends and holidays.' },
  { name: 'Mount Fuji Fujinomiya Trail', city: 'Fujinomiya', prefecture: 'Shizuoka', details: 'Shortest and steepest route starting from the Fujinomiya 5th Station.', adventure_name: 'Hiking', tips: 'Direct path to summit; several huts available. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Steep and rigorous; no separate descent trail.' },
  { name: 'Mount Fuji Subashiri Trail', city: 'Oyama', prefecture: 'Shizuoka', details: 'Less crowded trail starting from the Subashiri 5th Station, merging with Yoshida Trail near the 8th Station.', adventure_name: 'Hiking', tips: 'Lush forests in lower sections; fewer crowds. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Fewer huts and amenities than Yoshida Trail.' },
  { name: 'Mount Fuji Gotemba Trail', city: 'Gotemba', prefecture: 'Shizuoka', details: 'Longest route starting from the Gotemba 5th Station at a lower elevation.', adventure_name: 'Hiking', tips: 'Best for experienced hikers; fewer crowds. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Limited huts; longer ascent due to low starting elevation.' },
  { name: 'Mount Fuji Fujisan Hotel', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'Mountain hut at the 8th Station on the Yoshida Trail.', adventure_name: 'Overnight Stay', tips: 'Meals and lodging available; book in advance. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Can be crowded during peak season; basic facilities.' },
  { name: 'Mount Fuji Goraikoukan', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'Mountain hut near the 8th Station on the Yoshida Trail.', adventure_name: 'Overnight Stay', tips: 'Good for early summit attempts; meals provided. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Early booking essential due to high demand.' },
  { name: 'Mount Fuji Tomoekan', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'Mountain hut at the 7th Station on the Yoshida Trail.', adventure_name: 'Overnight Stay', tips: 'Private rooms available; family-friendly. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Limited capacity; books up fast.' },
  { name: 'Mount Fuji Taishikan', city: 'Fujiyoshida', prefecture: 'Yamanashi', details: 'Mountain hut at the 8th Station on the Yoshida Trail.', adventure_name: 'Overnight Stay', tips: 'Lodging and meals; good for acclimatization. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Basic facilities; early reservation advised.' },
  { name: 'Mount Fuji Hōei Sansō', city: 'Fujinomiya', prefecture: 'Shizuoka', details: 'Mountain hut at the 7th Station on the Fujinomiya Trail.', adventure_name: 'Overnight Stay', tips: 'Meals and sleeping areas available. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Steep trail; ensure physical readiness.' },
  { name: 'Mount Fuji Waraji-kan', city: 'Gotemba', prefecture: 'Shizuoka', details: 'Mountain hut at the 7th Station on the Gotemba Trail.', adventure_name: 'Overnight Stay', tips: 'Basic lodging; fewer crowds. Huts open only July–Sept; basic facilities, reservations required.', warnings: 'Limited amenities; for experienced hikers.' }

])

# link locations to adventures
locations.each do |location|
 matching_adventure = adventures.find { |a| a.name == location.adventure_name }
 location.adventures << matching_adventure if matching_adventure
end

# basic users
User.create!([
  {email: 'user1@example.com', password: 'password'},
  {email: 'user2@example.com', password: 'password'}
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

# travel plans
user1 = User.first
user2 = User.second

TravelPlan.create!([
  {
    user: user1,
    title: 'Weekend at Ogawayama',
    content: 'Multi-pitch climbing trip',
    status: 'pending'
  },
  {
    user: user2,
    title: 'Mount Takao Day Hike',
    content: 'Day trip hiking various trails',
    status: 'pending'
  }
]).each_with_index do |plan, index|
  plan.locations << (index.zero? ? Location.find_by(name: 'Ogawayama') : Location.find_by(name: 'Mount Takao'))
  plan.adventures << (index.zero? ? Adventure.find_by(name: 'Rock Climbing') : Adventure.find_by(name: 'Hiking'))
end
