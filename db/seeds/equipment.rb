# db/seeds/equipment.rb
def create_equipment
  puts "Creating equipment..."

  # First clear existing equipment associations
  TravelPlanEquipment.destroy_all
  LocationEquipment.destroy_all
  AdventureEquipment.destroy_all

  # Basic equipment (always recommended)
  basic = [
    { name: "First Aid Kit", description: "Basic medical supplies", category: "safety" },
    { name: "Water Bottle", description: "For hydration", category: "essential" },
    { name: "Backpack (30-40L)", description: "Day pack with hydration compatibility", category: "essential" }
  ]

  # Seasonal equipment
  summer = [
    { name: "Sun Hat", description: "Protection from sun", category: "clothing", summer_recommended: true },
    { name: "Sunscreen", description: "SPF 30+ protection", category: "safety", summer_recommended: true },
    { name: "Quick-dry Clothing", description: "Lightweight, moisture-wicking clothes", category: "clothing", summer_recommended: true }
  ]

  winter = [
    { name: "Thermal Layers", description: "Base layer for warmth", category: "clothing", winter_recommended: true },
    { name: "Snow Boots", description: "Waterproof winter boots", category: "footwear", winter_recommended: true },
    { name: "Hand Warmers", description: "Chemical heat packs", category: "comfort", winter_recommended: true }
  ]

  # Activity-specific equipment
  hiking = [
    { name: "Trekking Poles", description: "Adjustable poles for stability on varied terrain", category: "hiking" },
    { name: "Hiking Boots", description: "Waterproof boots with good ankle support for rough terrain", category: "footwear" },
    { name: "Map and Compass", description: "Navigation tools for backcountry travel", category: "navigation" },
    { name: "Rain Jacket", description: "Waterproof, breathable shell", category: "clothing" },
    { name: "Water Filter", description: "Portable water purification system", category: "safety" }
  ]

  climbing = [
    { name: "Climbing Harness", description: "Safety-rated climbing harness with gear loops", category: "climbing" },
    { name: "Climbing Shoes", description: "Tight-fitting shoes with sticky rubber soles", category: "footwear" },
    { name: "Chalk Bag", description: "For grip while climbing", category: "climbing" },
    { name: "Helmet", description: "Safety helmet for climbing and cycling", category: "safety" },
    { name: "Rope (60m)", description: "Dynamic climbing rope", category: "climbing" }
  ]

  camping = [
    { name: "Tent", description: "3-season backpacking tent", category: "shelter" },
    { name: "Sleeping Bag", description: "Temperature appropriate sleeping bag", category: "shelter" },
    { name: "Sleeping Pad", description: "Insulated sleeping pad for comfort and warmth", category: "shelter" },
    { name: "Headlamp", description: "Hands-free lighting for dawn/dusk activities", category: "essential" }
  ]

  # Location-specific equipment
  mt_fuji = [
    { name: "Altitude Sickness Pills", description: "For high altitude comfort", category: "safety" },
    { name: "Headlamp", description: "For early morning summit attempts", category: "essential" },
    { name: "Oxygen Canister", description: "Emergency oxygen supply", category: "safety" }
  ]

  # Create all equipment
  [basic, summer, winter, hiking, climbing, camping, mt_fuji].flatten.each do |equip|
    Equipment.find_or_create_by!(name: equip[:name]) do |equipment|
      equipment.description = equip[:description]
      equipment.category = equip[:category]
    end
  end

  puts "Created basic equipment"

  # Associate equipment with adventures
  Adventure.all.each do |adventure|
    case adventure.name.downcase
    when /hiking|trekking|walking/
      adventure.equipments << Equipment.where(name: [
        "Hiking Boots",
        "Backpack (30-40L)",
        "First Aid Kit",
        "Water Filter",
        "Trekking Poles",
        "Rain Jacket",
        "Map and Compass"
      ])
    when /climbing|bouldering/
      adventure.equipments << Equipment.where(name: [
        "Climbing Harness",
        "Climbing Shoes",
        "Helmet",
        "Rope (60m)",
        "First Aid Kit",
        "Chalk Bag"
      ])
    when /camping|overnight/
      adventure.equipments << Equipment.where(name: [
        "Tent",
        "Sleeping Bag",
        "Sleeping Pad",
        "Headlamp",
        "First Aid Kit",
        "Water Filter"
      ])
    end
  end

  puts "Associated equipment with adventures"

  # Associate equipment with locations
  Location.all.each do |location|
    # Base equipment for all mountain locations
    if location.name.downcase.match?(/mountain|mt\./)
      location.equipments << Equipment.where(name: [
        "Hiking Boots",
        "First Aid Kit",
        "Water Filter",
        "Rain Jacket",
        "Map and Compass"
      ])
    end

    # Add specific equipment based on location
    if location.name.downcase.match?(/fuji/)
      location.equipments << Equipment.where(name: [
        "Altitude Sickness Pills",
        "Oxygen Canister",
        "Headlamp",
        "Trekking Poles"
      ])
    end
  end

  puts "Associated equipment with locations"
end
