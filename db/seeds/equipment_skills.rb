# db/seeds/equipment_skills.rb
def create_equipment_skills
  puts "Creating equipment skills relationships..."

  equipment_skills_data = [
    {
      name: "Map & Compass Navigation",
      details: "Using topographic maps and compass to navigate in the wilderness",
      difficulty: "intermediate",
      category: "navigation",
      instructions: "1. Orient the map to north\n2. Identify landmarks on the map\n3. Use the compass to take bearings\n4. Follow a bearing while accounting for declination",
      safety_critical: true
    },
    {
      name: "Climbing Harness Setup",
      details: "Properly wearing and adjusting a climbing harness for safety",
      difficulty: "beginner",
      category: "climbing",
      instructions: "1. Step into leg loops\n2. Pull waistbelt up to waist\n3. Tighten waistbelt above hip bones\n4. Adjust leg loops for comfort\n5. Double-check all buckles",
      safety_critical: true
    },
    {
      name: "Avalanche Transceiver Use",
      details: "Using a beacon/transceiver to locate buried victims in an avalanche",
      difficulty: "intermediate",
      category: "safety",
      instructions: "1. Switch to search mode\n2. Move methodically across debris field\n3. Follow signal strength indicators\n4. Use fine search pattern when close\n5. Probe to confirm location before digging",
      safety_critical: true
    },
    {
      name: "Water Filtration",
      details: "Properly filtering and treating water from natural sources",
      difficulty: "beginner",
      category: "survival",
      instructions: "1. Collect water from moving sources when possible\n2. Remove large particles with prefilter if available\n3. Pump water through filter into clean container\n4. Follow manufacturer's instructions for backflushing",
      safety_critical: true
    },
    {
      name: "Bear Canister Usage",
      details: "Properly using a bear canister to protect food in the backcountry",
      difficulty: "beginner",
      category: "camping",
      instructions: "1. Pack all scented items (food, toiletries, trash)\n2. Seal canister tightly\n3. Store 100+ meters from campsite\n4. Place in location where it can't be rolled away",
      safety_critical: true
    },
    {
      name: "Crampons Application",
      details: "Properly fitting and walking with crampons on ice and snow",
      difficulty: "intermediate",
      category: "mountaineering",
      instructions: "1. Ensure boots are compatible with crampons\n2. Adjust crampon size to match boot\n3. Secure all straps and clips\n4. Walk with feet slightly wider apart than normal\n5. Lift feet to avoid tripping",
      safety_critical: true
    },
    {
      name: "Proper Layering",
      details: "Using the layering system to regulate body temperature in the outdoors",
      difficulty: "beginner",
      category: "clothing",
      instructions: "1. Start with moisture-wicking base layer\n2. Add insulating mid-layer\n3. Top with weather-appropriate shell\n4. Adjust layers based on activity level and conditions\n5. Don't wait until you're cold/hot to adjust",
      safety_critical: false
    },
    {
      name: "Headlamp Operation",
      details: "Effectively using a headlamp for navigation and camp tasks",
      difficulty: "beginner",
      category: "equipment",
      instructions: "1. Test battery life before trip\n2. Carry spare batteries\n3. Learn different brightness modes\n4. Use red light to preserve night vision\n5. Keep spare batteries warm in cold weather",
      safety_critical: false
    },
    {
      name: "Sleeping Pad Inflation",
      details: "Properly inflating and maintaining sleeping pads",
      difficulty: "beginner",
      category: "camping",
      instructions: "1. Find flat ground clear of sharp objects\n2. Unroll pad and open valve\n3. Inflate to desired firmness\n4. Close valve securely\n5. Store inflated at home, deflated in the field",
      safety_critical: false
    },
    {
      name: "Trekking Pole Adjustment",
      details: "Setting up and using trekking poles for stability and efficiency",
      difficulty: "beginner",
      category: "hiking",
      instructions: "1. Adjust length to create 90° angle at elbow\n2. Shorten for uphill, lengthen for downhill\n3. Use straps correctly to reduce grip fatigue\n4. Plant poles ahead on descents for stability\n5. Use alternating pattern for flat terrain",
      safety_critical: false
    }
  ]

  # creates the skills if they don't exist
  equipment_skills_data.each do |skill_data|
    Skill.find_or_create_by(name: skill_data[:name]) do |skill|
      skill.details = skill_data[:details]
      skill.difficulty = skill_data[:difficulty]
      skill.category = skill_data[:category]
      skill.instructions = skill_data[:instructions]
      skill.safety_critical = skill_data[:safety_critical]
    end
  end

  # create the associations between equipment and skills
  equipment_skill_associations = [
    { equipment: "Compass", skills: ["Map & Compass Navigation"], required: true },
    { equipment: "Trail Map", skills: ["Map & Compass Navigation"], required: true },
    { equipment: "Climbing Harness", skills: ["Climbing Harness Setup"], required: true },
    { equipment: "Avalanche Beacon", skills: ["Avalanche Transceiver Use"], required: true },
    { equipment: "Water Filter", skills: ["Water Filtration"], required: true },
    { equipment: "Bear Canister", skills: ["Bear Canister Usage"], required: true },
    { equipment: "Crampons", skills: ["Crampons Application"], required: true },
    { equipment: "Thermal Layers", skills: ["Proper Layering"], required: false },
    { equipment: "Insulated Jacket", skills: ["Proper Layering"], required: false },
    { equipment: "Rain Jacket", skills: ["Proper Layering"], required: false },
    { equipment: "Headlamp", skills: ["Headlamp Operation"], required: false },
    { equipment: "Sleeping Pad", skills: ["Sleeping Pad Inflation"], required: false },
    { equipment: "Trekking Poles", skills: ["Trekking Pole Adjustment"], required: false },
    # Let us add more associations as needed
  ]

  # create the associations
  equipment_skill_associations.each do |assoc|
    # find the equipment
    equipment = Equipment.find_by(name: assoc[:equipment])
    next unless equipment

    # find each skill and create the association
    assoc[:skills].each do |skill_name|
      skill = Skill.find_by(name: skill_name)
      next unless skill

      # create the association if it doesn't exist
      equipment_skill = EquipmentSkill.find_or_create_by(
        equipment: equipment,
        skill: skill
      ) do |es|
        es.is_required = assoc[:required]
        es.usage_tips = "For proper use of #{equipment.name}, knowledge of #{skill.name} is #{assoc[:required] ? 'required' : 'recommended'}"
      end
    end
  end

  puts "Created #{EquipmentSkill.count} equipment-skill associations"
end
