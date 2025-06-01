# db/seeds/quizzes.rb
def create_quizzes
  puts "Creating quizzes and questions..."

  # General wilderness survival quiz
  wilderness_quiz = Quiz.create!(
    title: "Wilderness Survival Basics",
    description: "Test your knowledge of basic wilderness survival skills and principles.",
    category: "survival",
    difficulty: "beginner"
  )

  # Questions for wilderness quiz
  wilderness_questions = [
    {
      content: "What is the Rule of 3 in survival?",
      difficulty: "easy",
      explanation: "The Rule of 3 is a guideline for survival priorities: you can survive 3 minutes without air, 3 hours without shelter in harsh conditions, 3 days without water, and 3 weeks without food.",
      answers: [
        { content: "You can survive 3 minutes without air, 3 hours without shelter, 3 days without water, and 3 weeks without food.", is_correct: true },
        { content: "You need 3 tools, 3 types of food, and 3 water sources to survive.", is_correct: false },
        { content: "You should always travel with 3 people for safety in the wilderness.", is_correct: false },
        { content: "You can survive 3 hours without air, 3 days without shelter, 3 weeks without water.", is_correct: false }
      ]
    },
    {
      content: "What should be your first priority in a survival situation?",
      difficulty: "easy",
      explanation: "Establishing shelter is crucial to protect yourself from the elements, especially in harsh conditions where exposure can be life-threatening.",
      answers: [
        { content: "Finding food", is_correct: false },
        { content: "Building a shelter", is_correct: true },
        { content: "Starting a fire", is_correct: false },
        { content: "Signaling for help", is_correct: false }
      ]
    },
    {
      content: "Which of these is NOT a safe source of drinking water in a survival situation?",
      difficulty: "medium",
      explanation: "Snow is not a good source because it requires energy to melt and can lower your body temperature if eaten directly. The other options, when properly collected and purified, are generally safer.",
      answers: [
        { content: "Rain water collected in a clean container", is_correct: false },
        { content: "Water from a fast-moving stream (after filtering/purifying)", is_correct: false },
        { content: "Morning dew collected from non-toxic plants", is_correct: false },
        { content: "Snow eaten directly without melting", is_correct: true }
      ]
    },
    {
      content: "What is the universal distress signal?",
      difficulty: "medium",
      explanation: "The universal distress signal is three of anything - three fires in a triangle, three gunshots, three whistle blasts, three flashes of light, or SOS (... --- ...).",
      answers: [
        { content: "One long whistle blast", is_correct: false },
        { content: "Two fires placed side by side", is_correct: false },
        { content: "Three of anything (whistles, fires, flashes)", is_correct: true },
        { content: "Four short whistle blasts", is_correct: false }
      ]
    },
    {
      content: "When lost in the wilderness, what is the recommended course of action?",
      difficulty: "medium",
      explanation: "STOP stands for Stop, Think, Observe, Plan. Staying put reduces energy expenditure and makes it easier for rescuers to find you if people know your general location.",
      answers: [
        { content: "Immediately begin looking for water and food sources", is_correct: false },
        { content: "Follow a downhill path until you reach civilization", is_correct: false },
        { content: "STOP (Stop, Think, Observe, Plan) and stay put if possible", is_correct: true },
        { content: "Travel only at night when it's cooler", is_correct: false }
      ]
    },
    {
      content: "Which knot is best for securing a load that might shift or loosen over time?",
      difficulty: "hard",
      explanation: "The trucker's hitch creates a mechanical advantage for tensioning lines and securing loads that might shift. It's commonly used for securing tarps, tents, and loads on vehicles.",
      answers: [
        { content: "Square knot", is_correct: false },
        { content: "Bowline", is_correct: false },
        { content: "Trucker's hitch", is_correct: true },
        { content: "Clove hitch", is_correct: false }
      ]
    },
    {
      content: "In cold weather, what type of shelter is most effective for heat retention?",
      difficulty: "hard",
      explanation: "A snow cave utilizes snow's insulating properties to maintain a temperature significantly warmer than outside air. When properly constructed, it can maintain a temperature around freezing even when external temperatures are much lower.",
      answers: [
        { content: "A-frame tarp shelter", is_correct: false },
        { content: "Lean-to with reflector wall", is_correct: false },
        { content: "Snow cave", is_correct: true },
        { content: "Natural rock overhang", is_correct: false }
      ]
    }
  ]

  # Create questions and answers for wilderness quiz
  create_questions_and_answers(wilderness_quiz, wilderness_questions)

  # Navigation quiz
  navigation_quiz = Quiz.create!(
    title: "Wilderness Navigation Essentials",
    description: "Test your knowledge of map reading, compass use, and natural navigation methods.",
    category: "navigation",
    difficulty: "intermediate"
  )

  # Questions for navigation quiz
  navigation_questions = [
    {
      content: "What does the contour line spacing on a topographic map indicate?",
      difficulty: "medium",
      explanation: "Closely spaced contour lines indicate steep terrain, while widely spaced lines indicate gentler slopes. Each contour line connects points of equal elevation.",
      answers: [
        { content: "The time it takes to hike between points", is_correct: false },
        { content: "The steepness of the terrain", is_correct: true },
        { content: "The type of vegetation in an area", is_correct: false },
        { content: "The distance between trails", is_correct: false }
      ]
    },
    {
      content: "What is declination in compass navigation?",
      difficulty: "medium",
      explanation: "Magnetic declination is the angle between magnetic north (where the compass points) and true north (the North Pole). This varies depending on your location and must be adjusted for accurate navigation.",
      answers: [
        { content: "The downward slope of terrain", is_correct: false },
        { content: "The wearing down of a compass over time", is_correct: false },
        { content: "The difference between true north and magnetic north", is_correct: true },
        { content: "The angle of the sun at noon", is_correct: false }
      ]
    },
    {
      content: "In the Northern Hemisphere, which side of trees typically has more moss growth?",
      difficulty: "easy",
      explanation: "In the Northern Hemisphere, the north side of trees, rocks, and other objects generally receives less sunlight, creating a more conducive environment for moss growth due to increased moisture retention.",
      answers: [
        { content: "East side", is_correct: false },
        { content: "South side", is_correct: false },
        { content: "West side", is_correct: false },
        { content: "North side", is_correct: true }
      ]
    },
    {
      content: "How do you orient a map using a compass?",
      difficulty: "hard",
      explanation: "To orient a map with a compass, you place the compass edge along the north-south grid line, rotate the map and compass together until the compass needle aligns with the orienting arrow (adjusting for declination), which aligns the map with the actual terrain.",
      answers: [
        { content: "Place the compass anywhere on the map and turn the map until north on the map faces north", is_correct: false },
        { content: "Place the compass edge along a north-south grid line, rotate until the needle aligns with the orienting arrow", is_correct: true },
        { content: "Point the direction of travel arrow toward your destination", is_correct: false },
        { content: "Set the compass to 0 degrees and place it on the center of the map", is_correct: false }
      ]
    },
    {
      content: "What navigation technique involves identifying your current location by observing the surrounding landscape features?",
      difficulty: "medium",
      explanation: "Triangulation involves taking bearings to at least two (ideally three) known landmarks, drawing these bearings on your map, and finding your location at their intersection.",
      answers: [
        { content: "Dead reckoning", is_correct: false },
        { content: "Triangulation", is_correct: true },
        { content: "Baseline navigation", is_correct: false },
        { content: "Terrain association", is_correct: false }
      ]
    }
  ]

  # Create questions and answers for navigation quiz
  create_questions_and_answers(navigation_quiz, navigation_questions)

  # First Aid quiz
  first_aid_quiz = Quiz.create!(
    title: "Wilderness First Aid",
    description: "Test your knowledge of handling medical emergencies in remote outdoor settings.",
    category: "first_aid",
    difficulty: "intermediate"
  )

  # Questions for first aid quiz
  first_aid_questions = [
    {
      content: "What is the first step in treating a suspected sprained ankle in a wilderness setting?",
      difficulty: "medium",
      explanation: "RICE stands for Rest, Ice (or cold), Compression, and Elevation. Rest prevents further injury, cold reduces swelling, compression helps limit swelling, and elevation reduces blood flow to the area.",
      answers: [
        { content: "Apply heat to reduce pain", is_correct: false },
        { content: "Massage the area to promote blood flow", is_correct: false },
        { content: "Apply the RICE protocol (Rest, Ice, Compression, Elevation)", is_correct: true },
        { content: "Continue hiking to 'walk it off'", is_correct: false }
      ]
    },
    {
      content: "What is the appropriate treatment for mild hypothermia in the field?",
      difficulty: "hard",
      explanation: "For mild hypothermia, it's crucial to prevent further heat loss and help the body generate heat naturally. Removing wet clothes, adding dry insulation, providing warm sweet drinks, and sharing body heat are effective strategies.",
      answers: [
        { content: "Immerse the victim in hot water", is_correct: false },
        { content: "Give the victim alcohol to warm up", is_correct: false },
        { content: "Remove wet clothing, add insulation, provide warm drinks, and share body heat", is_correct: true },
        { content: "Have the victim exercise vigorously to generate heat", is_correct: false }
      ]
    },
    {
      content: "What is the proper way to remove a tick?",
      difficulty: "easy",
      explanation: "Using fine-tipped tweezers to grasp the tick as close to the skin as possible and pulling straight up with steady pressure is the recommended method to remove a tick without leaving parts behind or increasing the risk of disease transmission.",
      answers: [
        { content: "Burn it with a match to make it back out", is_correct: false },
        { content: "Apply petroleum jelly to suffocate it, then remove", is_correct: false },
        { content: "Grasp it with tweezers close to the skin and pull straight up with steady pressure", is_correct: true },
        { content: "Twist it counterclockwise until it releases", is_correct: false }
      ]
    },
    {
      content: "What is the primary concern when treating a snake bite in the wilderness?",
      difficulty: "medium",
      explanation: "Keeping the victim calm and the bite below heart level helps slow venom circulation. Immediately seeking medical attention is crucial, as is avoiding outdated treatments like suction or tourniquets that can cause more harm.",
      answers: [
        { content: "Cutting the bite and sucking out the venom", is_correct: false },
        { content: "Applying a tourniquet above the bite", is_correct: false },
        { content: "Keeping the victim calm and the bite below heart level while seeking medical help", is_correct: true },
        { content: "Applying heat to neutralize the venom", is_correct: false }
# db/seeds/quizzes.rb (continued)
]
},
{
  content: "Which is NOT a sign of dehydration?",
  difficulty: "easy",
  explanation: "Pale, clear urine is actually a sign of good hydration. Dark yellow urine, headache, dry mouth, and dizziness are all signs of dehydration.",
  answers: [
    { content: "Dark yellow urine", is_correct: false },
    { content: "Headache", is_correct: false },
    { content: "Pale, clear urine", is_correct: true },
    { content: "Dizziness when standing up", is_correct: false }
  ]
}
]

# Create questions and answers for first aid quiz
create_questions_and_answers(first_aid_quiz, first_aid_questions)

# Weather quiz
weather_quiz = Quiz.create!(
title: "Mountain Weather Awareness",
description: "Test your knowledge of mountain weather patterns, forecasting, and safety.",
category: "weather",
difficulty: "advanced"
)

# Questions for weather quiz
weather_questions = [
{
  content: "Which cloud formation often indicates an approaching thunderstorm?",
  difficulty: "medium",
  explanation: "Cumulonimbus clouds, characterized by their tall, anvil-shaped tops, are thunderstorm clouds that can bring heavy rain, lightning, hail, and strong winds.",
  answers: [
    { content: "Cirrus clouds", is_correct: false },
    { content: "Stratus clouds", is_correct: false },
    { content: "Cumulonimbus clouds", is_correct: true },
    { content: "Nimbostratus clouds", is_correct: false }
  ]
},
{
  content: "What is the safest action to take when caught in a lightning storm while hiking?",
  difficulty: "hard",
  explanation: "When in a lightning storm, you should descend from ridges and peaks, avoid isolated trees, get away from metal objects, assume the lightning position (crouched with feet together) in a low area, and stay away from water.",
  answers: [
    { content: "Seek shelter under the tallest tree", is_correct: false },
    { content: "Lie flat on the ground to minimize exposure", is_correct: false },
    { content: "Get to lower elevation, away from ridges and isolated trees, and assume the lightning position", is_correct: true },
    { content: "Continue hiking to get out of the storm as quickly as possible", is_correct: false }
  ]
},
{
  content: "In Japan, during which month is the rainy season (tsuyu) typically most intense?",
  difficulty: "medium",
  explanation: "The rainy season or tsuyu in Japan typically reaches its peak in June, though the exact timing can vary by region, with southern areas experiencing it earlier than northern regions.",
  answers: [
    { content: "April", is_correct: false },
    { content: "June", is_correct: true },
    { content: "August", is_correct: false },
    { content: "October", is_correct: false }
  ]
},
{
  content: "What feature of mountain topography can create dangerous downslope winds?",
  difficulty: "hard",
  explanation: "Mountain passes and narrow canyons can funnel wind, creating a venturi effect that accelerates wind speed. These downslope winds can be sudden and powerful, creating hazardous conditions.",
  answers: [
    { content: "Wide, open valleys", is_correct: false },
    { content: "Dense forests", is_correct: false },
    { content: "Mountain passes and narrow canyons", is_correct: true },
    { content: "Lakes and rivers", is_correct: false }
  ]
},
{
  content: "What is an altimeter and how is it affected by weather changes?",
  difficulty: "hard",
  explanation: "An altimeter measures elevation based on atmospheric pressure. Since weather systems affect air pressure, an altimeter's reading can change with weather even at the same elevation. Lower pressure systems make altimeters read higher than actual elevation.",
  answers: [
    { content: "A device that measures wind speed; it's not affected by weather", is_correct: false },
    { content: "A device that measures elevation based on atmospheric pressure; readings increase when pressure drops", is_correct: true },
    { content: "A device that measures humidity; it's only affected by rainfall", is_correct: false },
    { content: "A device that measures temperature; readings decrease during storms", is_correct: false }
  ]
}
]

# Create questions and answers for weather quiz
create_questions_and_answers(weather_quiz, weather_questions)

# Equipment-specific quiz
compass_quiz = Quiz.create!(
title: "Mastering Your Compass",
description: "Test your knowledge of compass use and navigation techniques.",
category: "equipment",
difficulty: "intermediate",
equipment_id: Equipment.find_by(name: "Compass")&.id
)

# Questions for compass quiz
compass_questions = [
{
  content: "What is the 'declination adjustment' on a compass used for?",
  difficulty: "medium",
  explanation: "The declination adjustment allows you to account for the difference between magnetic north and true north. This varies based on location and is essential for accurate navigation.",
  answers: [
    { content: "To adjust for changes in latitude", is_correct: false },
    { content: "To compensate for the difference between magnetic north and true north", is_correct: true },
    { content: "To adjust the compass for different elevations", is_correct: false },
    { content: "To calibrate the compass for different hemispheres", is_correct: false }
  ]
},
{
  content: "When taking a bearing with a compass, what should you do with the bezel (rotating ring)?",
  difficulty: "medium",
  explanation: "To take a bearing, you point the direction of travel arrow at your target, then rotate the bezel until the orienting arrow aligns with the magnetic needle (putting 'red in the shed'). The bearing is then read at the index line.",
  answers: [
    { content: "Leave it at 0 degrees", is_correct: false },
    { content: "Rotate it until the magnetic needle points to your destination", is_correct: false },
    { content: "Rotate it until the orienting arrow aligns with the magnetic needle", is_correct: true },
    { content: "Remove it to take an accurate reading", is_correct: false }
  ]
},
{
  content: "What does it mean to 'boxing the compass'?",
  difficulty: "hard",
  explanation: "Boxing the compass refers to naming all 32 points of the compass in order (N, NNE, NE, ENE, E, etc.). It's a traditional navigational skill that demonstrates thorough knowledge of compass directions.",
  answers: [
    { content: "Storing a compass properly in its protective case", is_correct: false },
    { content: "Reciting all 32 points of the compass in order", is_correct: true },
    { content: "Walking in a square pattern to calibrate a compass", is_correct: false },
    { content: "Taking bearings from four cardinal directions to confirm position", is_correct: false }
  ]
},
{
  content: "What is 'shooting a back bearing' used for?",
  difficulty: "hard",
  explanation: "A back bearing (reverse bearing) is the opposite direction of your forward bearing (180° difference). It's useful for checking your path traveled, returning to your starting point, or verifying your position relative to a landmark.",
  answers: [
    { content: "Finding your way back to your starting point", is_correct: true },
    { content: "Measuring the height of a mountain", is_correct: false },
    { content: "Calibrating a compass at the equator", is_correct: false },
    { content: "Determining the time of day using the sun", is_correct: false }
  ]
},
{
  content: "What is parallax error in compass reading?",
  difficulty: "medium",
  explanation: "Parallax error occurs when your eye position isn't directly above the compass when taking a reading, causing an incorrect angle measurement. To avoid this, always hold the compass at eye level and look directly down on it when taking bearings.",
  answers: [
    { content: "Interference from nearby metal objects", is_correct: false },
    { content: "The error caused by magnetic declination", is_correct: false },
    { content: "The error from viewing the compass from an angle rather than directly above", is_correct: true },
    { content: "The difference between true north and grid north", is_correct: false }
  ]
}
]

# Create questions and answers for compass quiz
create_questions_and_answers(compass_quiz, compass_questions)

# Skill-specific quiz
water_filtration_quiz = Quiz.create!(
title: "Water Safety in the Wilderness",
description: "Test your knowledge of finding, treating, and using water in the backcountry.",
category: "survival",
difficulty: "intermediate",
skill_id: Skill.find_by(name: "Water Filtration")&.id
)

# Questions for water filtration quiz
water_filtration_questions = [
{
  content: "Which water source is generally safest in the wilderness?",
  difficulty: "easy",
  explanation: "Moving water from springs and fast-flowing streams is typically safer than stagnant water because it contains more oxygen and supports fewer harmful organisms. However, all wilderness water should still be treated.",
  answers: [
    { content: "Lake water near the shore", is_correct: false },
    { content: "Spring water or fast-moving stream", is_correct: true },
    { content: "Water from a slow-moving river", is_correct: false },
    { content: "Melted snow without treatment", is_correct: false }
  ]
},
{
  content: "Which of these contaminants is NOT typically removed by mechanical filtration?",
  difficulty: "medium",
  explanation: "Most portable water filters can remove bacteria and protozoa but cannot remove viruses because viruses are too small for the filter pores. Chemical treatment or other methods are needed for viruses.",
  answers: [
    { content: "Sediment and particles", is_correct: false },
    { content: "Bacteria like E. coli", is_correct: false },
    { content: "Protozoa like Giardia", is_correct: false },
    { content: "Viruses", is_correct: true }
  ]
},
{
  content: "How does boiling water make it safe to drink?",
  difficulty: "medium",
  explanation: "Boiling water kills disease-causing organisms including bacteria, viruses, and protozoa by exposing them to high temperatures they cannot survive. At sea level, water should be brought to a rolling boil for at least 1 minute.",
  answers: [
    { content: "It removes chemical contaminants", is_correct: false },
    { content: "It kills pathogenic organisms with high temperature", is_correct: true },
    { content: "It causes heavy metals to settle to the bottom", is_correct: false },
    { content: "It increases oxygen content making it safer", is_correct: false }
  ]
},
{
  content: "When using a pump-style water filter, what should you do if the pumping becomes difficult?",
  difficulty: "medium",
  explanation: "Difficult pumping often indicates a clogged filter. Backflushing (reversing the flow) clears trapped particles and extends filter life. Many filters have specific backflushing procedures in their instructions.",
  answers: [
    { content: "Pump harder to force water through", is_correct: false },
    { content: "Add a small amount of chlorine to the water first", is_correct: false },
    { content: "Backflush the filter according to manufacturer instructions", is_correct: true },
    { content: "Replace the filter element immediately", is_correct: false }
  ]
},
{
  content: "What is the main advantage of using ultraviolet (UV) light for water treatment?",
  difficulty: "hard",
  explanation: "UV light treatment is quick (often under 90 seconds), effective against viruses, bacteria, and protozoa, adds no taste to the water, and requires no wait time after treatment. However, it requires batteries and clear water to be effective.",
  answers: [
    { content: "It works even with muddy or cloudy water", is_correct: false },
    { content: "It removes chemical pollutants", is_correct: false },
    { content: "It's quick and doesn't add chemicals or taste", is_correct: true },
    { content: "It works without batteries or power source", is_correct: false }
  ]
}
]

# Create questions and answers for water filtration quiz
create_questions_and_answers(water_filtration_quiz, water_filtration_questions)

puts "Created #{Quiz.count} quizzes with #{Question.count} questions and #{Answer.count} answers"
end

# Helper method to create questions and answers
def create_questions_and_answers(quiz, questions_data)
questions_data.each do |question_data|
question = quiz.questions.create!(
  content: question_data[:content],
  difficulty: question_data[:difficulty],
  explanation: question_data[:explanation]
)

question_data[:answers].each do |answer_data|
  question.answers.create!(
    content: answer_data[:content],
    is_correct: answer_data[:is_correct]
  )
end
end
end
