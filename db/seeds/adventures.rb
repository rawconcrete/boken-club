# db/seeds/adventures.rb
def create_adventures
  puts "creating adventures..."

  adventures = Adventure.create!([
    { name: 'Hiking', details: "explore japan's diverse mountain trails and natural scenery", tips: "bring proper hiking boots and plenty of water", warnings: "check weather conditions and trail closures before departing" },
    { name: 'Rock Climbing', details: "scale japan's world-class climbing spots", tips: "always climb with a partner and proper safety gear", warnings: "verify route conditions and ensure your skill level matches" },
    { name: 'Camping', details: "experience overnight stays in japan's wilderness", tips: "reserve campsites in advance during peak seasons", warnings: "store food properly to avoid wildlife encounters" },
    { name: 'Trekking', details: "long-distance walking through rugged terrain", tips: "prepare for multi-day hikes with proper gear", warnings: "requires endurance and careful planning" },
    { name: 'Kayaking', details: "paddle through scenic rivers, lakes, and coastal waters", tips: "check local regulations and wear a life vest", warnings: "be cautious of strong currents and changing tides" },
    { name: 'Caving', details: "explore underground caves and lava tubes", tips: "bring a helmet and headlamp", warnings: "watch out for slippery rocks and confined spaces" },
    { name: 'Snowshoeing', details: "trek through japan's snowy landscapes in winter", tips: "wear waterproof boots and dress in layers", warnings: "check avalanche risk and weather conditions" },
    { name: 'Skiing & Snowboarding', details: "enjoy japan's famous powder snow at top ski resorts", tips: "rent or bring high-quality gear for the best experience", warnings: "be aware of off-piste dangers and changing conditions" },
    { name: 'Wildlife Watching', details: "observe japan's unique wildlife in its natural habitat", tips: "bring binoculars and move quietly to avoid disturbing animals", warnings: "maintain a safe distance and avoid feeding wildlife" },
    { name: 'Fishing', details: "catch fish in japan's rivers, lakes, and coastal waters", tips: "obtain a fishing permit if required", warnings: "be aware of local fishing regulations and seasonal restrictions" },
    { name: 'Trail Running', details: "run through scenic mountain trails and forests", tips: "wear trail running shoes with good grip", warnings: "be cautious of uneven terrain and wildlife encounters" },
    { name: 'Cycling', details: "ride through japan's countryside and scenic coastal routes", tips: "check local cycling routes and bring repair tools", warnings: "watch out for traffic and road conditions" },
    { name: 'Paragliding', details: "soar above japan's mountains and coastlines", tips: "book with a certified instructor if you're a beginner", warnings: "be mindful of wind conditions and landing zones" },
    { name: 'Rafting', details: "navigate japan's thrilling whitewater rapids", tips: "wear a helmet and life vest for safety", warnings: "only attempt advanced rapids with proper training" },
    { name: 'Diving', details: "explore coral reefs and underwater caves in japan's seas", tips: "use a certified diving guide for the best spots", warnings: "be cautious of strong currents and marine life" },
    { name: 'Star Gazing', details: "enjoy clear night skies from remote areas", tips: "bring a telescope or binoculars for a better view", warnings: "check weather conditions and avoid light pollution" },
    { name: 'Castle Touring', details: "explore japan's historic castles and cultural heritage", tips: "wear comfortable shoes and check opening times", warnings: "crowds may be heavy during peak seasons" },
    { name: 'Mountaineering', details: "challenge yourself on hyogo's rugged mountains", tips: "use proper safety gear and plan your route", warnings: "ensure weather conditions are favourable" }
  ])

  puts "created #{Adventure.count} adventures"
end
