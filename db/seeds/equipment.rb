# db/seeds/equipment.rb
# basic equipment (always recommended)
basic = [
  { name: "First Aid Kit", description: "Basic medical supplies", category: "safety" },
  { name: "Water Bottle", description: "For hydration", category: "essential" },
  { name: "Backpack", description: "Day pack for carrying essentials", category: "essential" }
]

# seasonal equipment
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

# activity-specific equipment
hiking = [
  { name: "Trekking Poles", description: "For stability on trails" },
  { name: "Hiking Boots", description: "Sturdy footwear for trails" },
  { name: "Trail Map", description: "Navigation aid" }
]

climbing = [
  { name: "Climbing Harness", description: "Safety equipment for climbing" },
  { name: "Climbing Shoes", description: "Specialized footwear for climbing" },
  { name: "Chalk Bag", description: "For grip while climbing" }
]

# location-specific equipment
mt_fuji = [
  { name: "Altitude Sickness Pills", description: "For high altitude comfort" },
  { name: "Headlamp", description: "For early morning summit attempts" },
  { name: "Oxygen Canister", description: "Emergency oxygen supply" }
]

# create all equipment
[basic, summer, winter, hiking, climbing, mt_fuji].flatten.each do |equip|
  Equipment.create!(equip)
end

# associate equipment with locations and adventures
Location.find_by(name: "Mount Fuji")&.tap do |fuji|
  mt_fuji.each do |equip|
    equipment = Equipment.find_by(name: equip[:name])
    LocationEquipment.create!(location: fuji, equipment: equipment)
  end
end

Adventure.find_by(name: "Hiking")&.tap do |hiking_adv|
  hiking.each do |equip|
    equipment = Equipment.find_by(name: equip[:name])
    AdventureEquipment.create!(adventure: hiking_adv, equipment: equipment)
  end
end
