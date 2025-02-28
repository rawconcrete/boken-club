# db/seeds/skills.rb
def create_skills
  puts "Creating skills..."

  skills_data = [
    {
      name: "Map Reading & Navigation",
      details: "The ability to read topographic maps, use a compass, and navigate in wilderness areas.",
      difficulty: "intermediate",
      category: "navigation",
      instructions: "1. Learn to identify terrain features on a map\n2. Practice using a compass to find north\n3. Understand contour lines and elevation\n4. Learn to triangulate your position\n5. Practice route planning with map and compass",
      resources: "Books:\n- 'Wilderness Navigation' by Bob Burns\n- 'Be Expert with Map and Compass' by Bjorn Kjellstrom\n\nWebsites:\n- REI Navigation Basics\n- National Geographic Map Skills",
      video_url: "https://www.youtube.com/embed/0cF0ovA3FtY",
      safety_critical: true
    },
    {
      name: "Campsite Selection",
      details: "Selecting a safe, comfortable, and environmentally responsible campsite.",
      difficulty: "beginner",
      category: "camping",
      instructions: "1. Look for flat ground with good drainage\n2. Avoid areas under dead trees or branches\n3. Consider proximity to water sources\n4. Check for signs of wildlife activity\n5. Stay away from avalanche paths in winter",
      resources: "- 'NOLS Wilderness Guide' by Mark Harvey\n- Leave No Trace Center for Outdoor Ethics website",
      video_url: "https://www.youtube.com/embed/nXMM8sQMHik",
      safety_critical: false
    },
    {
      name: "Fire Building",
      details: "Safely creating and maintaining a campfire in wilderness settings.",
      difficulty: "beginner",
      category: "survival",
      instructions: "1. Check if fires are allowed in your area\n2. Clear an area of flammable materials\n3. Gather tinder, kindling, and fuel wood\n4. Build a fire structure (teepee, log cabin, etc.)\n5. Light the tinder at the base\n6. Maintain and fully extinguish when done",
      resources: "- 'Bushcraft 101' by Dave Canterbury\n- 'Essential Wilderness Navigation' by Craig Caudill",
      video_url: "https://www.youtube.com/embed/aDr6h6PrN8k",
      safety_critical: true
    },
    {
      name: "Tent Pitching",
      details: "Setting up a tent properly to ensure stability and protection from elements.",
      difficulty: "beginner",
      category: "camping",
      instructions: "1. Find level ground free of rocks and roots\n2. Lay out the footprint if you have one\n3. Assemble poles according to instructions\n4. Attach tent body to poles\n5. Stake down corners with slight tension\n6. Apply rainfly and guy lines\n7. Adjust for proper ventilation",
      resources: "- REI's tent setup guides\n- Specific tent manufacturer instructions",
      video_url: "https://www.youtube.com/embed/SPIq72pkF4A",
      safety_critical: false
    },
    {
      name: "Water Purification",
      details: "Methods to make natural water sources safe for drinking in the wilderness.",
      difficulty: "beginner",
      category: "survival",
      instructions: "1. Always treat water from natural sources\n2. Boiling: Rolling boil for at least 1 minute (3 minutes at high elevations)\n3. Filtration: Use a quality water filter with appropriate pore size\n4. Chemical treatment: Follow instructions for tablets or drops\n5. UV light: Use as directed by device manufacturer",
      resources: "- CDC guidelines for water treatment\n- 'NOLS Wilderness Medicine' by Tod Schimelpfenig",
      video_url: "https://www.youtube.com/embed/XrcrX9Qaw2o",
      safety_critical: true
    },
    {
      name: "Bear Safety",
      details: "Techniques to prevent bear encounters and respond appropriately if they occur.",
      difficulty: "intermediate",
      category: "safety",
      instructions: "1. Make noise while hiking\n2. Store food and scented items properly (bear canister/hang)\n3. Cook and eat away from your sleeping area\n4. If you encounter a bear: don't run, speak calmly, back away slowly\n5. Know the difference between defensive and predatory behavior\n6. Carry and know how to use bear spray in bear country",
      resources: "- National Park Service bear safety guidelines\n- 'Bear Attacks: Their Causes and Avoidance' by Stephen Herrero",
      video_url: "https://www.youtube.com/embed/PExlT-5VU-Y",
      safety_critical: true
    },
    {
      name: "Wilderness First Aid",
      details: "Basic medical skills for addressing injuries and illnesses in remote settings.",
      difficulty: "intermediate",
      category: "first_aid",
      instructions: "1. Complete a wilderness first aid course\n2. Learn to assess and stabilize patients\n3. Practice wound cleaning and bandaging\n4. Understand treatment for common injuries like sprains\n5. Know how to recognize and respond to hypothermia and heat exhaustion\n6. Practice improvising with limited resources",
      resources: "- NOLS Wilderness First Aid curriculum\n- 'Wilderness First Aid' by Alton Thygerson\n- Red Cross Wilderness First Aid classes",
      video_url: "https://www.youtube.com/embed/WnxVJjpQ9Xw",
      safety_critical: true
    },
    {
      name: "Knot Tying",
      details: "Essential knots for camping, climbing, and other outdoor activities.",
      difficulty: "beginner",
      category: "camping",
      instructions: "1. Start with basic knots: bowline, square knot, clove hitch, taut-line hitch\n2. Practice until you can tie them quickly and correctly\n3. Learn when each knot is appropriate to use\n4. Test knots under tension before relying on them\n5. Progress to more specialized knots for specific activities",
      resources: "- 'The Ashley Book of Knots' by Clifford Ashley\n- Animated Knots website and app",
      video_url: "https://www.youtube.com/embed/1FaypwbCPbs",
      safety_critical: false
    },
    {
      name: "Weather Reading",
      details: "Recognizing weather patterns and signs to predict changes and potential hazards.",
      difficulty: "intermediate",
      category: "safety",
      instructions: "1. Learn to identify cloud types and what they indicate\n2. Understand how pressure changes affect weather\n3. Recognize signs of approaching storms\n4. Monitor trends in temperature, wind, and clouds\n5. Know local weather patterns for the region you're exploring",
      resources: "- 'Reading Weather' by Jim Woodmencey\n- National Weather Service educational resources",
      video_url: "https://www.youtube.com/embed/58Zcbt707Pk",
      safety_critical: true
    },
    {
      name: "Leave No Trace Principles",
      details: "Ethics and practices for minimizing impact on natural environments.",
      difficulty: "beginner",
      category: "environmental",
      instructions: "1. Plan ahead and prepare\n2. Travel and camp on durable surfaces\n3. Dispose of waste properly\n4. Leave what you find\n5. Minimize campfire impacts\n6. Respect wildlife\n7. Be considerate of other visitors",
      resources: "- Leave No Trace Center for Outdoor Ethics website\n- 'Soft Paths' by Bruce Hampton and David Cole",
      video_url: "https://www.youtube.com/embed/jXvFrjnUi2k",
      safety_critical: false
    },
    {
      name: "Rock Climbing Basics",
      details: "Fundamental techniques and safety practices for climbing rock faces.",
      difficulty: "intermediate",
      category: "climbing",
      instructions: "1. Take an introductory course with certified instructors\n2. Learn proper gear usage and safety checks\n3. Practice belaying techniques\n4. Understand climbing grades and route selection\n5. Master fundamental moves: edging, smearing, jamming\n6. Always climb with proper spotting/belaying",
      resources: "- 'Rock Climbing: Mastering Basic Skills' by Craig Luebben\n- American Alpine Club safety resources",
      video_url: "https://www.youtube.com/embed/gLfvk2SSj1c",
      safety_critical: true
    },
    {
      name: "River Crossing",
      details: "Safe techniques for fording streams and rivers in the wilderness.",
      difficulty: "advanced",
      category: "water",
      instructions: "1. Assess if crossing is necessary and safe\n2. Scout for the best crossing location\n3. Unbuckle backpack waist and chest straps\n4. Use a walking stick or trekking poles for stability\n5. Cross with multiple people in a triangle formation if possible\n6. Face upstream and move diagonally with the current\n7. Know when conditions are too dangerous to cross",
      resources: "- 'Freedom of the Hills' by The Mountaineers\n- 'NOLS Wilderness Guide' chapter on river crossings",
      video_url: "https://www.youtube.com/embed/5gGdoFQYkdE",
      safety_critical: true
    },
    {
      name: "Winter Camping",
      details: "Specialized skills for camping in snow and cold conditions.",
      difficulty: "advanced",
      category: "camping",
      instructions: "1. Use proper insulated gear and layering systems\n2. Create a solid tent platform in snow\n3. Learn to manage moisture to prevent hypothermia\n4. Melt snow efficiently for water\n5. Properly store food and water to prevent freezing\n6. Recognize and prevent frostbite and hypothermia",
      resources: "- 'Winter in the Wilderness' by Dave Hall\n- 'NOLS Winter Camping' by Buck Tilton",
      video_url: "https://www.youtube.com/embed/0stTHC80w2s",
      safety_critical: true
    },
    {
      name: "Avalanche Safety",
      details: "Knowledge and skills to assess avalanche risk and respond to avalanche emergencies.",
      difficulty: "advanced",
      category: "safety",
      instructions: "1. Take a formal avalanche safety course\n2. Learn to read avalanche forecasts\n3. Practice using avalanche safety gear (beacon, probe, shovel)\n4. Understand snow pack assessment techniques\n5. Plan routes that minimize avalanche risk\n6. Know rescue procedures for avalanche burial",
      resources: "- 'Staying Alive in Avalanche Terrain' by Bruce Tremper\n- Avalanche.org training resources",
      video_url: "https://www.youtube.com/embed/9qOFAMavGg4",
      safety_critical: true
    },
    {
      name: "Backcountry Cooking",
      details: "Preparing nutritious meals efficiently with minimal equipment in wilderness settings.",
      difficulty: "beginner",
      category: "camping",
      instructions: "1. Plan meals before your trip\n2. Use lightweight, calorie-dense foods\n3. Master one-pot meals\n4. Learn efficient stove use and fuel conservation\n5. Properly store food to prevent wildlife encounters\n6. Practice leave-no-trace washing up",
      resources: "- 'NOLS Cookery' by Claudia Pearson\n- 'The Backpacker's Field Manual' chapter on nutrition",
      video_url: "https://www.youtube.com/embed/MVqbVecQwEk",
      safety_critical: false
    },
    {
      name: "Trail Etiquette",
      details: "Social norms and practices for respectful trail use.",
      difficulty: "beginner",
      category: "environmental",
      instructions: "1. Yield to uphill hikers\n2. Step aside for faster hikers\n3. Understand right-of-way hierarchy (horses > hikers > cyclists)\n4. Keep noise levels appropriate\n5. Stay on established trails\n6. Pack out all trash, including biodegradable items",
      resources: "- American Hiking Society trail etiquette guide\n- Local trail organization guidelines",
      video_url: "https://www.youtube.com/embed/wDhLKGDCHzU",
      safety_critical: false
    },
    {
      name: "Backcountry Navigation with GPS",
      details: "Using GPS devices and smartphone apps for wilderness navigation while understanding their limitations.",
      difficulty: "intermediate",
      category: "navigation",
      instructions: "1. Learn to use your specific GPS device or app before heading out\n2. Always carry physical maps and compass as backup\n3. Understand coordinate systems and datum settings\n4. Pre-download maps for offline use\n5. Conserve battery power through proper settings\n6. Track your route and set waypoints at key locations",
      resources: "- 'GPS Made Easy' by Lawrence Letham\n- Gaia GPS tutorials\n- AllTrails user guides",
      video_url: "https://www.youtube.com/embed/V9qOU8Z5ws0",
      safety_critical: false
    },
    {
      name: "Backpack Fitting and Packing",
      details: "Properly fitting a backpack to your body and efficiently organizing gear for comfort and accessibility.",
      difficulty: "beginner",
      category: "equipment",
      instructions: "1. Measure your torso length for correct pack size\n2. Adjust hip belt to sit on hip bones\n3. Tighten shoulder straps appropriately\n4. Pack heaviest items close to your back and centered\n5. Keep frequently used items accessible\n6. Balance weight evenly\n7. Use compression straps to stabilize load",
      resources: "- REI backpack fitting guides\n- 'The Ultimate Hiker's Gear Guide' by Andrew Skurka",
      video_url: "https://www.youtube.com/embed/0SGiGZlppMM",
      safety_critical: false
    },
    {
      name: "Wilderness Signaling",
      details: "Methods to signal for help in emergency situations in remote areas.",
      difficulty: "intermediate",
      category: "safety",
      instructions: "1. Universal distress signal: 3 of anything (whistle blasts, fires, etc.)\n2. Use signal mirror on sunny days\n3. Create large, visible ground signals in clearings\n4. Use whistle (carries further than voice)\n5. Know how to operate emergency beacons/PLBs\n6. Understand radio communications protocols if carrying",
      resources: "- 'Wilderness 911' by Eric Weiss\n- Search and Rescue organizations' recommendations",
      video_url: "https://www.youtube.com/embed/tvBxPbQFUWA",
      safety_critical: true
    },
    {
      name: "Layering for Mountain Weather",
      details: "Using clothing layers strategically to maintain comfort and safety in variable mountain conditions.",
      difficulty: "beginner",
      category: "equipment",
      instructions: "1. Start with moisture-wicking base layer\n2. Add insulating mid-layer(s) as needed\n3. Top with waterproof/windproof shell\n4. Adjust layers before you get too hot or cold\n5. Keep a dry set of clothes for camp/sleeping\n6. Understand materials and their properties (down vs. synthetic, etc.)",
      resources: "- 'Mountaineering: Freedom of the Hills' clothing chapter\n- Outdoor Research layering guide",
      video_url: "https://www.youtube.com/embed/Wbu1E6yz_OY",
      safety_critical: true
    }
  ]

  # Create all the skills
  skills_data.each do |skill_data|
    Skill.create!(skill_data)
  end

  puts "Created #{Skill.count} skills"

  # Associate skills with adventures
  adventure_skills = {
    "Hiking" => ["Map Reading & Navigation", "Weather Reading", "Trail Etiquette", "Bear Safety", "Wilderness First Aid", "Backcountry Navigation with GPS", "Backpack Fitting and Packing", "Layering for Mountain Weather"],

    "Rock Climbing" => ["Rock Climbing Basics", "Knot Tying", "Weather Reading", "Wilderness First Aid", "Wilderness Signaling"],

    "Camping" => ["Campsite Selection", "Tent Pitching", "Fire Building", "Water Purification", "Bear Safety", "Knot Tying", "Leave No Trace Principles", "Backcountry Cooking", "Backpack Fitting and Packing"],

    "Trekking" => ["Map Reading & Navigation", "Wilderness First Aid", "Water Purification", "River Crossing", "Campsite Selection", "Weather Reading", "Tent Pitching", "Backcountry Navigation with GPS", "Backpack Fitting and Packing", "Layering for Mountain Weather"],

    "Kayaking" => ["Water Purification", "Weather Reading", "Wilderness First Aid", "Wilderness Signaling"],

    "Caving" => ["Wilderness First Aid", "Knot Tying", "Wilderness Signaling"],

    "Snowshoeing" => ["Map Reading & Navigation", "Winter Camping", "Avalanche Safety", "Weather Reading", "Wilderness First Aid", "Layering for Mountain Weather"],

    "Skiing & Snowboarding" => ["Avalanche Safety", "Winter Camping", "Weather Reading", "Wilderness First Aid", "Layering for Mountain Weather"],

    "Mountaineering" => ["Map Reading & Navigation", "Knot Tying", "Weather Reading", "Avalanche Safety", "Wilderness First Aid", "Winter Camping", "Wilderness Signaling", "Layering for Mountain Weather"]
  }

  # Create the associations
  adventure_skills.each do |adventure_name, skill_names|
    adventure = Adventure.find_by(name: adventure_name)
    next unless adventure

    skill_names.each do |skill_name|
      skill = Skill.find_by(name: skill_name)
      next unless skill

      # Create the association with some required and some optional
      is_required = %w[Map\ Reading\ &\ Navigation Wilderness\ First\ Aid Weather\ Reading Avalanche\ Safety Water\ Purification].include?(skill_name)

      AdventureSkill.create!(
        adventure: adventure,
        skill: skill,
        is_required: is_required
      )
    end
  end

  # Associate skills with specific locations
  location_skills = {
    "Mount Fuji Fujiyoshida 5th Station" => ["Winter Camping", "Map Reading & Navigation", "Weather Reading", "Layering for Mountain Weather"],
    "Shiretoko National Park" => ["Bear Safety", "Map Reading & Navigation", "Weather Reading", "Wilderness First Aid"],
    "Zao Mountain Range" => ["Avalanche Safety", "Winter Camping", "Weather Reading", "Map Reading & Navigation"],
    "Mount Tanigawa" => ["Avalanche Safety", "Weather Reading", "Rock Climbing Basics", "Wilderness First Aid", "Wilderness Signaling"]
  }

  # Create the associations
  location_skills.each do |location_name, skill_names|
    location = Location.find_by(name: location_name)
    next unless location

    skill_names.each do |skill_name|
      skill = Skill.find_by(name: skill_name)
      next unless skill

      # Create the association with some required and some optional
      is_required = %w[Avalanche\ Safety Bear\ Safety].include?(skill_name)

      LocationSkill.create!(
        location: location,
        skill: skill,
        is_required: is_required
      )
    end
  end

  puts "Created #{AdventureSkill.count} adventure-skill associations"
  puts "Created #{LocationSkill.count} location-skill associations"
end
# old db/seeds/skills.rb
# def create_skills
#   puts "Creating skills..."

#   skills = [
#     { name: 'Building a Campfire', details: "Gather dry wood, tinder, and kindling. Build a fire structure like a teepee or log cabin. Use matches or a fire starter to ignite it, ensuring proper airflow." },

#     { name: 'Navigating with a Map and Compass', details: "Orient the map using landmarks or a compass. Identify your current position and set a bearing toward your destination, adjusting as needed." },

#     { name: 'Purifying Water', details: "Use a portable filter, boil water for at least one minute, or use purification tablets to kill bacteria and viruses before drinking." },

#     { name: 'Setting Up a Tent', details: "Choose a flat, dry area. Lay out the tent footprint, assemble poles, and secure the tent with stakes and guy lines for stability." },

#     { name: 'Tying Essential Knots', details: "Learn knots like the bowline (for securing loads), clove hitch (for fastening to a post), and taut-line hitch (for adjustable tension on guy lines)." },

#     { name: 'Identifying Edible Plants', details: "Research local edible plants before the trip. Avoid plants with white berries, milky sap, or an almond-like scent, which may indicate toxicity." },

#     { name: 'Emergency Signaling', details: "Use a whistle (three blasts for distress), create large visible signals (rocks, fire, or bright clothing), and use a mirror to reflect sunlight." },

#     { name: 'First Aid Basics', details: "Carry a first aid kit and know how to treat cuts, burns, sprains, and insect bites. Learn CPR and how to use a tourniquet in emergencies." },

#     { name: 'Wildlife Awareness and Safety', details: "Store food properly to avoid attracting animals. Make noise while hiking in bear country, and know how to react to different wildlife encounters." },

#     { name: 'Reading Weather Signs', details: "Observe cloud formations, wind changes, and barometric pressure drops to anticipate storms or temperature shifts and take necessary precautions." }
# ]
#   skills.each do |skill|
#       Skill.create!(skill)
#   end

#   puts "created #{Skill.count} skills"
# end
