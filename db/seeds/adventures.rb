# db/seeds/adventures.rb
def create_adventures
  puts "Creating adventures..."

  adventures = Adventure.create!([
    { name: 'Hiking', details: "Explore Japan's diverse mountain trails and natural scenery", tips: 'Bring proper hiking boots and plenty of water', warnings: 'Check weather conditions and trail closures before departing' },
    { name: 'Rock Climbing', details: "Scale Japan's world-class climbing spots", tips: 'Always climb with a partner and proper safety gear', warnings: 'Verify route conditions and ensure your skill level matches' },
    { name: 'Camping', details: "Experience overnight stays in Japan's wilderness", tips: 'Reserve campsites in advance during peak seasons', warnings: 'Store food properly to avoid wildlife encounters' },
    { name: 'Trekking', details: 'Long-distance walking through rugged terrain', tips: 'Prepare for multi-day hikes with proper gear', warnings: 'Requires endurance and careful planning' },
    { name: 'Kayaking', details: 'Paddle through scenic rivers, lakes, and coastal waters', tips: 'Check local regulations and wear a life vest', warnings: 'Be cautious of strong currents and changing tides' },
    { name: 'Caving', details: 'Explore underground caves and lava tubes', tips: 'Bring a helmet and headlamp', warnings: 'Watch out for slippery rocks and confined spaces' },
    { name: 'Snowshoeing', details: "Trek through Japan's snowy landscapes in winter", tips: 'Wear waterproof boots and dress in layers', warnings: 'Check avalanche risk and weather conditions' },
    { name: 'Skiing & Snowboarding', details: "Enjoy Japan's famous powder snow at top ski resorts", tips: 'Rent or bring high-quality gear for the best experience', warnings: 'Be aware of off-piste dangers and changing conditions' },
    { name: 'Wildlife Watching', details: "Observe Japan's unique wildlife in its natural habitat", tips: 'Bring binoculars and move quietly to avoid disturbing animals', warnings: 'Maintain a safe distance and avoid feeding wildlife' },
    { name: 'Fishing', details: "Catch fish in Japan's rivers, lakes, and coastal waters", tips: 'Obtain a fishing permit if required', warnings: 'Be aware of local fishing regulations and seasonal restrictions' },
    { name: 'Trail Running', details: "Run through scenic mountain trails and forests", tips: 'Wear trail running shoes with good grip', warnings: 'Be cautious of uneven terrain and wildlife encounters' },
    { name: 'Cycling', details: "Ride through Japan's countryside and scenic coastal routes", tips: 'Check local cycling routes and bring repair tools', warnings: 'Watch out for traffic and road conditions' },
    { name: 'Paragliding', details: "Soar above Japan's mountains and coastlines", tips: 'Book with a certified instructor if you\'re a beginner', warnings: 'Be mindful of wind conditions and landing zones' },
    { name: 'Rafting', details: "Navigate Japan's thrilling whitewater rapids", tips: 'Wear a helmet and life vest for safety', warnings: 'Only attempt advanced rapids with proper training' },
    { name: 'Diving', details: "Explore coral reefs and underwater caves in Japan's seas", tips: 'Use a certified diving guide for the best spots', warnings: 'Be cautious of strong currents and marine life' },
    { name: 'Star Gazing', details: "Enjoy clear night skies from remote areas", tips: 'Bring a telescope or binoculars for a better view', warnings: 'Check weather conditions and avoid light pollution' }
  ])

  puts "Created #{Adventure.count} adventures"
end
