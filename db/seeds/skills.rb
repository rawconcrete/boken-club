# db/seeds/skills.rb
def create_skills
  puts "creating skills..."

  skills = [
    { name: 'Building a Campfire', details: "Gather dry wood, tinder, and kindling. Build a fire structure like a teepee or log cabin. Use matches or a fire starter to ignite it, ensuring proper airflow." },

    { name: 'Navigating with a Map and Compass', details: "Orient the map using landmarks or a compass. Identify your current position and set a bearing toward your destination, adjusting as needed." },

    { name: 'Purifying Water', details: "Use a portable filter, boil water for at least one minute, or use purification tablets to kill bacteria and viruses before drinking." },

    { name: 'Setting Up a Tent', details: "Choose a flat, dry area. Lay out the tent footprint, assemble poles, and secure the tent with stakes and guy lines for stability." },

    { name: 'Tying Essential Knots', details: "Learn knots like the bowline (for securing loads), clove hitch (for fastening to a post), and taut-line hitch (for adjustable tension on guy lines)." },

    { name: 'Identifying Edible Plants', details: "Research local edible plants before the trip. Avoid plants with white berries, milky sap, or an almond-like scent, which may indicate toxicity." },

    { name: 'Emergency Signaling', details: "Use a whistle (three blasts for distress), create large visible signals (rocks, fire, or bright clothing), and use a mirror to reflect sunlight." },

    { name: 'First Aid Basics', details: "Carry a first aid kit and know how to treat cuts, burns, sprains, and insect bites. Learn CPR and how to use a tourniquet in emergencies." },

    { name: 'Wildlife Awareness and Safety', details: "Store food properly to avoid attracting animals. Make noise while hiking in bear country, and know how to react to different wildlife encounters." },

    { name: 'Reading Weather Signs', details: "Observe cloud formations, wind changes, and barometric pressure drops to anticipate storms or temperature shifts and take necessary precautions." }
]
  skills.each do |skill|
      Skill.create!(skill)
  end

  puts "created #{Skill.count} skills"
end
