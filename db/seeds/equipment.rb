# db/seeds/equipment.rb
def create_equipment
  puts "creating equipment..."

  # clear existing associations and equipment
  TravelPlanEquipment.destroy_all
  LocationEquipment.destroy_all
  AdventureEquipment.destroy_all
  Equipment.destroy_all

  # equipment data
  equipment_data = [
    # basic equipment
    { name: "First Aid Kit", description: "basic medical supplies", category: "safety" },
    { name: "Water Bottle", description: "for hydration", category: "essential" },
    { name: "Backpack (30-40L)", description: "day pack with hydration compatibility", category: "essential" },
    { name: "Multi-tool", description: "versatile tool for minor repairs", category: "essential" },
    { name: "Flashlight", description: "portable light source", category: "essential" },
    { name: "Emergency Blanket", description: "compact thermal blanket", category: "safety" },
    { name: "Power Bank", description: "portable battery charger", category: "essential" },
    { name: "Walking Shoes", description: "comfortable shoes for walking tours", category: "footwear" },
    { name: "Mountaineering Boots", description: "durable boots for mountaineering", category: "footwear" },
    { name: "Ice Axe", description: "tool for climbing icy slopes", category: "climbing" },

    # seasonal - summer
    { name: "Sun Hat", description: "protection from sun", category: "clothing", summer_recommended: true },
    { name: "Sunscreen", description: "spf 30+ protection", category: "safety", summer_recommended: true },
    { name: "Quick-dry Clothing", description: "lightweight, moisture-wicking clothes", category: "clothing", summer_recommended: true },
    { name: "Mosquito Repellent", description: "protection from insects", category: "safety", summer_recommended: true },
    { name: "Cooling Towel", description: "stays cool when wet", category: "comfort", summer_recommended: true },

    # seasonal - winter
    { name: "Thermal Layers", description: "base layer for warmth", category: "clothing", winter_recommended: true },
    { name: "Snow Boots", description: "waterproof winter boots", category: "footwear", winter_recommended: true },
    { name: "Hand Warmers", description: "chemical heat packs", category: "comfort", winter_recommended: true },
    { name: "Insulated Jacket", description: "for extreme cold conditions", category: "clothing", winter_recommended: true },
    { name: "Wool Socks", description: "keep feet warm when wet", category: "clothing", winter_recommended: true },
    { name: "Thermos", description: "for hot drinks", category: "comfort", winter_recommended: true },

    # seasonal - spring
    { name: "Rain Jacket", description: "waterproof shell for spring showers", category: "clothing", spring_recommended: true },
    { name: "Packable Umbrella", description: "compact protection from rain", category: "comfort", spring_recommended: true },
    { name: "Waterproof Bag Cover", description: "keeps backpack contents dry", category: "essential", spring_recommended: true },

    # seasonal - autumn
    { name: "Layered Clothing", description: "for temperature variations", category: "clothing", autumn_recommended: true },
    { name: "Windbreaker", description: "light protection from wind", category: "clothing", autumn_recommended: true },
    { name: "Gloves", description: "for cool mornings", category: "clothing", autumn_recommended: true },

    # activity - hiking
    { name: "Hiking Boots", description: "sturdy footwear for trails", category: "footwear" },
    { name: "Trekking Poles", description: "for stability on rough terrain", category: "hiking" },
    { name: "Trail Map", description: "physical backup for navigation", category: "navigation" },
    { name: "Compass", description: "navigation tool for backcountry travel", category: "navigation" },
    { name: "GPS Device", description: "digital navigation with emergency features", category: "navigation" },
    { name: "Water Filter", description: "portable water purification system", category: "safety" },

    # activity - climbing
    { name: "Climbing Harness", description: "safety-rated climbing harness with gear loops", category: "climbing" },
    { name: "Climbing Shoes", description: "tight-fitting shoes with sticky rubber soles", category: "footwear" },
    { name: "Chalk Bag", description: "for grip while climbing", category: "climbing" },
    { name: "Helmet", description: "safety helmet for climbing", category: "safety" },
    { name: "Rope (60m)", description: "dynamic climbing rope", category: "climbing" },
    { name: "Quickdraws", description: "for sport climbing protection", category: "climbing" },
    { name: "Belay Device", description: "for belaying climbers", category: "climbing" },

    # activity - camping
    { name: "Tent", description: "3-season backpacking tent", category: "shelter" },
    { name: "Sleeping Bag", description: "temperature appropriate sleeping bag", category: "shelter" },
    { name: "Sleeping Pad", description: "insulated sleeping pad for comfort and warmth", category: "shelter" },
    { name: "Headlamp", description: "hands-free lighting for dawn/dusk activities", category: "essential" },
    { name: "Camping Stove", description: "portable stove for cooking", category: "cooking" },
    { name: "Cookware", description: "lightweight pots and utensils", category: "cooking" },
    { name: "Bear Canister", description: "for food storage in bear country", category: "safety" },

    # activity - skiing
    { name: "Ski Boots", description: "well-fitted boots for skiing", category: "footwear" },
    { name: "Skis", description: "appropriate for your skill level", category: "skiing" },
    { name: "Poles", description: "ski poles for balance", category: "skiing" },
    { name: "Goggles", description: "protection from snow glare", category: "safety" },
    { name: "Thermal Base Layers", description: "moisture-wicking first layer", category: "clothing" },
    { name: "Ski Jacket", description: "insulated, waterproof outer layer", category: "clothing" },

    # activity - kayaking
    { name: "Life Jacket", description: "personal flotation device", category: "safety" },
    { name: "Paddle", description: "proper size and weight for you", category: "kayaking" },
    { name: "Spray Skirt", description: "keeps water out of kayak", category: "kayaking" },
    { name: "Dry Bag", description: "waterproof storage for items", category: "essential" },
    { name: "Whistle", description: "emergency signalling device", category: "safety" },
    { name: "Quick-Dry Clothing", description: "for comfort on water", category: "clothing" },

    # location - mt. fuji
    { name: "Altitude Sickness Pills", description: "for high altitude comfort", category: "safety" },
    { name: "Oxygen Canister", description: "emergency oxygen supply", category: "safety" },
    { name: "Crampons", description: "for icy conditions near summit", category: "footwear" },

    # location - hokkaido
    { name: "Bear Bell", description: "alert wildlife to your presence", category: "safety" },
    { name: "Bear Spray", description: "emergency deterrent", category: "safety" },
    { name: "Extra Warm Clothing", description: "for sudden cold fronts", category: "clothing" },
    { name: "Satellite Phone", description: "for remote areas with no coverage", category: "communication" },

    # location - tropical
    { name: "Reef-Safe Sunscreen", description: "protects coral reefs", category: "safety" },
    { name: "Snorkel Gear", description: "for underwater exploration", category: "water" }
  ]

  equipment_data.each do |equip|
    Equipment.create!(
      name: equip[:name],
      description: equip[:description],
      category: equip[:category],
      summer_recommended: equip.fetch(:summer_recommended, false),
      winter_recommended: equip.fetch(:winter_recommended, false),
      spring_recommended: equip.fetch(:spring_recommended, false),
      autumn_recommended: equip.fetch(:autumn_recommended, false)
    )
  end

  puts "created #{Equipment.count} equipment items"

  # associate equipment with adventures
  Adventure.all.each do |adventure|
    case adventure.name.downcase
    when 'hiking', 'trekking', 'trail running'
      %w[
        Hiking\ Boots Backpack\ (30-40L) First\ Aid\ Kit Water\ Filter
        Trekking\ Poles Trail\ Map Compass Water\ Bottle
      ].each do |item|
        eq = Equipment.find_by(name: item)
        adventure.equipment << eq if eq
      end
    when 'rock climbing', 'bouldering'
      %w[
        Climbing\ Harness Climbing\ Shoes Helmet Rope\ (60m)
        First\ Aid\ Kit Chalk\ Bag Quickdraws Belay\ Device
      ].each do |item|
        eq = Equipment.find_by(name: item)
        adventure.equipment << eq if eq
      end
    when 'camping'
      %w[
        Tent Sleeping\ Bag Sleeping\ Pad Headlamp First\ Aid\ Kit
        Water\ Filter Camping\ Stove Cookware
      ].each do |item|
        eq = Equipment.find_by(name: item)
        adventure.equipment << eq if eq
      end
    when 'skiing & snowboarding'
      %w[
        Ski\ Boots Skis Poles Goggles Helmet Thermal\ Base\ Layers
        Ski\ Jacket First\ Aid\ Kit
      ].each do |item|
        eq = Equipment.find_by(name: item)
        adventure.equipment << eq if eq
      end
    when 'kayaking'
      %w[
        Life\ Jacket Paddle Spray\ Skirt Dry\ Bag Whistle
        Quick-Dry\ Clothing First\ Aid\ Kit Water\ Bottle
      ].each do |item|
        eq = Equipment.find_by(name: item)
        adventure.equipment << eq if eq
      end
    when 'castle touring'
      %w[
        First\ Aid\ Kit Water\ Bottle Backpack\ (30-40L)
        Walking\ Shoes Power\ Bank Multi-tool
      ].each do |item|
        eq = Equipment.find_by(name: item)
        adventure.equipment << eq if eq
      end
    when 'mountaineering'
      %w[
        Mountaineering\ Boots Ice\ Axe Hiking\ Boots Trekking\ Poles
        Compass GPS\ Device First\ Aid\ Kit Water\ Bottle Backpack\ (30-40L)
      ].each do |item|
        eq = Equipment.find_by(name: item)
        adventure.equipment << eq if eq
      end
    else
      %w[First\ Aid\ Kit Water\ Bottle Backpack\ (30-40L)].each do |item|
        eq = Equipment.find_by(name: item)
        adventure.equipment << eq if eq
      end
    end
  end

  puts "created #{AdventureEquipment.count} adventure-equipment associations"

  # associate equipment with locations
  Location.all.each do |location|
    # base equipment for every location
    %w[First\ Aid\ Kit Water\ Bottle Backpack\ (30-40L)].each do |item|
      eq = Equipment.find_by(name: item)
      location.equipment << eq if eq
    end

    if location.name.downcase.include?('fuji')
      %w[
        Altitude\ Sickness\ Pills Oxygen\ Canister Headlamp Crampons
        Trekking\ Poles
      ].each do |item|
        eq = Equipment.find_by(name: item)
        location.equipment << eq if eq
      end
    elsif location.name.downcase.include?('hokkaido') || location.prefecture.downcase == 'hokkaido'
      %w[
        Bear\ Bell Bear\ Spray Extra\ Warm\ Clothing Satellite\ Phone
      ].each do |item|
        eq = Equipment.find_by(name: item)
        location.equipment << eq if eq
      end
    elsif location.name.downcase.include?('takao')
      %w[Hiking\ Boots Trail\ Map Insect\ Repellent].each do |item|
        eq = Equipment.find_by(name: item)
        location.equipment << eq if eq
      end
    elsif location.name.downcase.match?(/lake|river|water|valley/)
      %w[Quick-Dry\ Clothing Insect\ Repellent Dry\ Bag Whistle].each do |item|
        eq = Equipment.find_by(name: item)
        location.equipment << eq if eq
      end
    elsif location.name.downcase.match?(/mountain|mt\.|mount/)
      %w[
        Hiking\ Boots Trekking\ Poles Compass GPS\ Device Extra\ Warm\ Clothing
      ].each do |item|
        eq = Equipment.find_by(name: item)
        location.equipment << eq if eq
      end
    end

    # additional associations for hyogo locations
    if location.prefecture.downcase == 'hyogo'
      if location.name.downcase.include?('himeji')
        %w[Walking\ Shoes Power\ Bank Multi-tool].each do |item|
          eq = Equipment.find_by(name: item)
          location.equipment << eq if eq
        end
      elsif location.name.downcase.include?('seppiko')
        %w[Mountaineering\ Boots Ice\ Axe].each do |item|
          eq = Equipment.find_by(name: item)
          location.equipment << eq if eq
        end
      end
    end
  end

  puts "created #{LocationEquipment.count} location-equipment associations"
end
