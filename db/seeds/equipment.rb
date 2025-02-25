# db/seeds/equipment.rb
def create_equipment
  puts "Creating equipment..."

  # First clear existing equipment associations
  TravelPlanEquipment.destroy_all
  LocationEquipment.destroy_all
  AdventureEquipment.destroy_all
  Equipment.destroy_all  # Start fresh with equipment too

  # Create basic equipment
  first_aid = Equipment.create!(name: "First Aid Kit", description: "Basic medical supplies", category: "safety")
  water_bottle = Equipment.create!(name: "Water Bottle", description: "For hydration", category: "essential")
  backpack = Equipment.create!(name: "Backpack (30-40L)", description: "Day pack with hydration compatibility", category: "essential")

  # Hiking equipment
  hiking_boots = Equipment.create!(name: "Hiking Boots", description: "Sturdy footwear for trails", category: "footwear")
  trekking_poles = Equipment.create!(name: "Trekking Poles", description: "For stability on rough terrain", category: "hiking")
  trail_map = Equipment.create!(name: "Trail Map", description: "Physical backup for navigation", category: "navigation")

  # Climbing equipment
  harness = Equipment.create!(name: "Climbing Harness", description: "For safety while climbing", category: "climbing")
  carabiners = Equipment.create!(name: "Carabiners", description: "Metal connectors for climbing", category: "climbing")
  helmet = Equipment.create!(name: "Climbing Helmet", description: "Head protection", category: "safety")

  # Mt. Fuji specific equipment
  altitude_pills = Equipment.create!(name: "Altitude Sickness Pills", description: "For high elevation comfort", category: "safety")
  oxygen = Equipment.create!(name: "Oxygen Canister", description: "Emergency oxygen", category: "safety")
  warm_layers = Equipment.create!(name: "Extra Warm Layers", description: "For cold summit temperatures", category: "clothing")

  puts "Created #{Equipment.count} equipment items"

  # Create the associations directly
  hiking = Adventure.find_by(name: 'Hiking')
  if hiking
    puts "Found hiking adventure: #{hiking.id}"
    AdventureEquipment.create!(adventure: hiking, equipment: hiking_boots)
    AdventureEquipment.create!(adventure: hiking, equipment: trekking_poles)
    AdventureEquipment.create!(adventure: hiking, equipment: trail_map)
    AdventureEquipment.create!(adventure: hiking, equipment: first_aid)
    AdventureEquipment.create!(adventure: hiking, equipment: water_bottle)
    AdventureEquipment.create!(adventure: hiking, equipment: backpack)
  else
    puts "ERROR: Hiking adventure not found!"
  end

  climbing = Adventure.find_by(name: 'Rock Climbing')
  if climbing
    puts "Found climbing adventure: #{climbing.id}"
    AdventureEquipment.create!(adventure: climbing, equipment: harness)
    AdventureEquipment.create!(adventure: climbing, equipment: carabiners)
    AdventureEquipment.create!(adventure: climbing, equipment: helmet)
    AdventureEquipment.create!(adventure: climbing, equipment: first_aid)
    AdventureEquipment.create!(adventure: climbing, equipment: water_bottle)
    AdventureEquipment.create!(adventure: climbing, equipment: backpack)
  else
    puts "ERROR: Rock Climbing adventure not found!"
  end

  fuji = Location.find_by(name: 'Mount Fuji Fujiyoshida 5th Station')
  if fuji
    puts "Found Mt. Fuji location: #{fuji.id}"
    LocationEquipment.create!(location: fuji, equipment: altitude_pills)
    LocationEquipment.create!(location: fuji, equipment: oxygen)
    LocationEquipment.create!(location: fuji, equipment: warm_layers)
    LocationEquipment.create!(location: fuji, equipment: first_aid)
    LocationEquipment.create!(location: fuji, equipment: water_bottle)
    LocationEquipment.create!(location: fuji, equipment: backpack)
  else
    puts "ERROR: Mt. Fuji location not found!"
  end

  puts "Created #{AdventureEquipment.count} adventure-equipment associations"
  puts "Created #{LocationEquipment.count} location-equipment associations"
end
# # db/seeds/equipment.rb
# def create_equipment
#   puts "Creating equipment..."

#   # first clear existing equipment associations
#   TravelPlanEquipment.destroy_all
#   LocationEquipment.destroy_all
#   AdventureEquipment.destroy_all

#   # basic equipment (always recommended)
#   basic = [
#     { name: "First Aid Kit", description: "Basic medical supplies", category: "safety" },
#     { name: "Water Bottle", description: "For hydration", category: "essential" },
#     { name: "Backpack (30-40L)", description: "Day pack with hydration compatibility", category: "essential" }
#   ]

#   # seasonal equipment
#   summer = [
#     { name: "Sun Hat", description: "Protection from sun", category: "clothing", summer_recommended: true },
#     { name: "Sunscreen", description: "SPF 30+ protection", category: "safety", summer_recommended: true },
#     { name: "Quick-dry Clothing", description: "Lightweight, moisture-wicking clothes", category: "clothing", summer_recommended: true },
#     { name: "Mosquito Repellent", description: "Protection from insects", category: "safety", summer_recommended: true },
#     { name: "Cooling Towel", description: "Stays cool when wet", category: "comfort", summer_recommended: true }
#   ]

#   winter = [
#     { name: "Thermal Layers", description: "Base layer for warmth", category: "clothing", winter_recommended: true },
#     { name: "Snow Boots", description: "Waterproof winter boots", category: "footwear", winter_recommended: true },
#     { name: "Hand Warmers", description: "Chemical heat packs", category: "comfort", winter_recommended: true },
#     { name: "Insulated Jacket", description: "For extreme cold conditions", category: "clothing", winter_recommended: true },
#     { name: "Wool Socks", description: "Keep feet warm when wet", category: "clothing", winter_recommended: true },
#     { name: "Thermos", description: "For hot drinks", category: "comfort", winter_recommended: true }
#   ]

#   spring = [
#     { name: "Rain Jacket", description: "Waterproof shell for spring showers", category: "clothing", spring_recommended: true },
#     { name: "Packable Umbrella", description: "Compact protection from rain", category: "comfort", spring_recommended: true },
#     { name: "Waterproof Bag Cover", description: "Keeps backpack contents dry", category: "essential", spring_recommended: true }
#   ]

#   autumn = [
#     { name: "Layered Clothing", description: "For temperature variations", category: "clothing", autumn_recommended: true },
#     { name: "Windbreaker", description: "Light protection from wind", category: "clothing", autumn_recommended: true },
#     { name: "Gloves", description: "For cool mornings", category: "clothing", autumn_recommended: true }
#   ]

#   # activity-specific equipment
#   hiking = [
#     { name: "Trekking Poles", description: "Adjustable poles for stability on varied terrain", category: "hiking" },
#     { name: "Hiking Boots", description: "Waterproof boots with good ankle support for rough terrain", category: "footwear" },
#     { name: "Trail Map", description: "Physical map as backup to digital", category: "navigation" },
#     { name: "Compass", description: "Navigation tool for backcountry travel", category: "navigation" },
#     { name: "GPS Device", description: "Digital navigation with emergency features", category: "navigation" },
#     { name: "Water Filter", description: "Portable water purification system", category: "safety" }
#   ]

#   climbing = [
#     { name: "Climbing Harness", description: "Safety-rated climbing harness with gear loops", category: "climbing" },
#     { name: "Climbing Shoes", description: "Tight-fitting shoes with sticky rubber soles", category: "footwear" },
#     { name: "Chalk Bag", description: "For grip while climbing", category: "climbing" },
#     { name: "Helmet", description: "Safety helmet for climbing", category: "safety" },
#     { name: "Rope (60m)", description: "Dynamic climbing rope", category: "climbing" },
#     { name: "Quickdraws", description: "For sport climbing protection", category: "climbing" },
#     { name: "Belay Device", description: "For belaying climbers", category: "climbing" }
#   ]

#   camping = [
#     { name: "Tent", description: "3-season backpacking tent", category: "shelter" },
#     { name: "Sleeping Bag", description: "Temperature appropriate sleeping bag", category: "shelter" },
#     { name: "Sleeping Pad", description: "Insulated sleeping pad for comfort and warmth", category: "shelter" },
#     { name: "Headlamp", description: "Hands-free lighting for dawn/dusk activities", category: "essential" },
#     { name: "Camping Stove", description: "Portable stove for cooking", category: "cooking" },
#     { name: "Cookware", description: "Lightweight pots and utensils", category: "cooking" },
#     { name: "Bear Canister", description: "For food storage in bear country", category: "safety" }
#   ]

#   skiing = [
#     { name: "Ski Boots", description: "Well-fitted boots for skiing", category: "footwear" },
#     { name: "Skis", description: "Appropriate for your skill level", category: "skiing" },
#     { name: "Poles", description: "Ski poles for balance", category: "skiing" },
#     { name: "Goggles", description: "Protection from snow glare", category: "safety" },
#     { name: "Helmet", description: "Head protection for skiing", category: "safety" },
#     { name: "Thermal Base Layers", description: "Moisture-wicking first layer", category: "clothing" },
#     { name: "Ski Jacket", description: "Insulated, waterproof outer layer", category: "clothing" }
#   ]

#   kayaking = [
#     { name: "Life Jacket", description: "Personal flotation device", category: "safety" },
#     { name: "Paddle", description: "Proper size and weight for you", category: "kayaking" },
#     { name: "Spray Skirt", description: "Keeps water out of kayak", category: "kayaking" },
#     { name: "Dry Bag", description: "Waterproof storage for items", category: "essential" },
#     { name: "Whistle", description: "Emergency signaling device", category: "safety" },
#     { name: "Quick-Dry Clothing", description: "For comfort on water", category: "clothing" }
#   ]

#   # location-specific equipment
#   mt_fuji = [
#     { name: "Altitude Sickness Pills", description: "For high altitude comfort", category: "safety" },
#     { name: "Headlamp", description: "For early morning summit attempts", category: "essential" },
#     { name: "Oxygen Canister", description: "Emergency oxygen supply", category: "safety" },
#     { name: "Crampons", description: "For icy conditions near summit", category: "footwear" }
#   ]

#   hokkaido = [
#     { name: "Bear Bell", description: "Alert wildlife to your presence", category: "safety" },
#     { name: "Bear Spray", description: "Emergency deterrent", category: "safety" },
#     { name: "Extra Warm Clothing", description: "For sudden cold fronts", category: "clothing" },
#     { name: "Satellite Phone", description: "For remote areas with no coverage", category: "communication" }
#   ]

#   tropical = [
#     { name: "Reef-Safe Sunscreen", description: "Protects coral reefs", category: "safety" },
#     { name: "Snorkel Gear", description: "For underwater exploration", category: "water" },
#     { name: "Dry Bag", description: "Keeps electronics safe from water", category: "essential" },
#     { name: "Insect Repellent", description: "Protection from tropical insects", category: "safety" }
#   ]

#   # create all equipment
#   all_equipment = [basic, summer, winter, spring, autumn, hiking, climbing, camping, skiing, kayaking, mt_fuji, hokkaido, tropical].flatten

#   all_equipment.each do |equip|
#     Equipment.find_or_create_by!(name: equip[:name]) do |equipment|
#       equipment.description = equip[:description]
#       equipment.category = equip[:category]
#       equipment.summer_recommended = equip[:summer_recommended] || false
#       equipment.winter_recommended = equip[:winter_recommended] || false
#       equipment.spring_recommended = equip[:spring_recommended] || false
#       equipment.autumn_recommended = equip[:autumn_recommended] || false
#     end
#   end

#   puts "Created basic equipment"

#   # associate equipment with adventures
#   Adventure.all.each do |adventure|
#     case adventure.name.downcase
#     when 'hiking', 'trekking', 'trail running'
#       adventure.equipment << Equipment.where(name: [
#         "Hiking Boots",
#         "Backpack (30-40L)",
#         "First Aid Kit",
#         "Water Filter",
#         "Trekking Poles",
#         "Trail Map",
#         "Compass",
#         "Water Bottle"
#       ])
#     when 'rock climbing', 'bouldering'
#       adventure.equipment << Equipment.where(name: [
#         "Climbing Harness",
#         "Climbing Shoes",
#         "Helmet",
#         "Rope (60m)",
#         "First Aid Kit",
#         "Chalk Bag",
#         "Quickdraws",
#         "Belay Device"
#       ])
#     when 'camping'
#       adventure.equipment << Equipment.where(name: [
#         "Tent",
#         "Sleeping Bag",
#         "Sleeping Pad",
#         "Headlamp",
#         "First Aid Kit",
#         "Water Filter",
#         "Camping Stove",
#         "Cookware"
#       ])
#     when 'skiing', 'snowboarding'
#       adventure.equipment << Equipment.where(name: [
#         "Ski Boots",
#         "Skis",
#         "Poles",
#         "Goggles",
#         "Helmet",
#         "Thermal Base Layers",
#         "Ski Jacket",
#         "First Aid Kit"
#       ])
#     when 'kayaking'
#       adventure.equipment << Equipment.where(name: [
#         "Life Jacket",
#         "Paddle",
#         "Spray Skirt",
#         "Dry Bag",
#         "Whistle",
#         "Quick-Dry Clothing",
#         "First Aid Kit",
#         "Water Bottle"
#       ])
#     else
#       # default basic equipment for all other activities
#       adventure.equipment << Equipment.where(name: [
#         "First Aid Kit",
#         "Water Bottle",
#         "Backpack (30-40L)"
#       ])
#     end
#   end

#   puts "Associated equipment with adventures"

#   # associate equipment with locations
#   Location.all.each do |location|
#     # base equipment for all locations
#     location.equipment << Equipment.where(name: [
#       "First Aid Kit",
#       "Water Bottle",
#       "Backpack (30-40L)"
#     ])

#     # add specific equipment based on location name
#     if location.name.downcase.match?(/fuji/)
#       location.equipment << Equipment.where(name: [
#         "Altitude Sickness Pills",
#         "Oxygen Canister",
#         "Headlamp",
#         "Crampons",
#         "Trekking Poles"
#       ])
#     elsif location.name.downcase.match?(/hokkaido/) || location.prefecture.downcase == 'hokkaido'
#       location.equipment << Equipment.where(name: [
#         "Bear Bell",
#         "Bear Spray",
#         "Extra Warm Clothing",
#         "Satellite Phone"
#       ])
#     elsif location.name.downcase.match?(/takao/)
#       location.equipment << Equipment.where(name: [
#         "Hiking Boots",
#         "Trail Map",
#         "Insect Repellent"
#       ])
#     elsif location.name.downcase.match?(/lake|river|water|valley/)
#       location.equipment << Equipment.where(name: [
#         "Quick-Dry Clothing",
#         "Insect Repellent",
#         "Dry Bag",
#         "Whistle"
#       ])
#     elsif location.name.downcase.match?(/mountain|mt\.|mount/)
#       location.equipment << Equipment.where(name: [
#         "Hiking Boots",
#         "Trekking Poles",
#         "Compass",
#         "GPS Device",
#         "Extra Warm Clothing"
#       ])
#     end

#     # add seasonal equipment based on prefecture
#     case location.prefecture.downcase
#     when 'hokkaido', 'aomori', 'akita', 'iwate'
#       location.equipment << Equipment.where(name: [
#         "Thermal Layers",
#         "Snow Boots",
#         "Insulated Jacket",
#         "Hand Warmers"
#       ])
#     when 'okinawa', 'kagoshima', 'miyazaki'
#       location.equipment << Equipment.where(name: [
#         "Reef-Safe Sunscreen",
#         "Snorkel Gear",
#         "Insect Repellent",
#         "Quick-dry Clothing"
#       ])
#     end
#   end

#   puts "Associated equipment with locations"
# end
