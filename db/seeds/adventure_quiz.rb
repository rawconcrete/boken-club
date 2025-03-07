# db/seeds/adventure_quiz.rb
# Use this file to seed the adventure recommendation quiz

puts "Creating Adventure Recommendation Quiz..."

# Create the main quiz
adventure_quiz = Quiz.find_or_create_by!(
  title: "Find Your Perfect Adventure",
  description: "Discover your ideal outdoor adventure based on your preferences, experience level, and interests. Get a personalized recommendation that matches your style!",
  difficulty: "easy",
  category: "recommendation"
)

# Create the questions and answers
questions_data = [
  {
    content: "What activity level do you prefer?",
    difficulty: "easy",
    answers: [
      { content: "Active - I want to challenge myself physically", is_correct: false, metadata: "active" },
      { content: "Moderate - I enjoy moving but don't want it too strenuous", is_correct: false, metadata: "moderate" },
      { content: "Relaxed - I prefer a more laid back experience", is_correct: false, metadata: "relaxed" }
    ]
  },
  {
    content: "What type of environment interests you most?",
    difficulty: "easy",
    answers: [
      { content: "Mountains - I love high peaks and challenging terrain", is_correct: false, metadata: "mountains" },
      { content: "Forests - I enjoy tree cover and wildlife", is_correct: false, metadata: "forests" },
      { content: "Water - I'm drawn to lakes, rivers, or oceans", is_correct: false, metadata: "water" },
      { content: "Cultural - I'm interested in historic or cultural sites", is_correct: false, metadata: "cultural" }
    ]
  },
  {
    content: "How much experience do you have with outdoor activities?",
    difficulty: "easy",
    answers: [
      { content: "Beginner - I'm new to outdoor adventures", is_correct: false, metadata: "beginner" },
      { content: "Intermediate - I have some experience", is_correct: false, metadata: "intermediate" },
      { content: "Advanced - I'm very experienced in outdoor activities", is_correct: false, metadata: "advanced" }
    ]
  },
  {
    content: "How long would you like your adventure to be?",
    difficulty: "easy",
    answers: [
      { content: "Day trip - Just a few hours", is_correct: false, metadata: "day" },
      { content: "Full day - From morning to evening", is_correct: false, metadata: "full_day" },
      { content: "Multi-day - An overnight or longer experience", is_correct: false, metadata: "multi_day" }
    ]
  },
  {
    content: "What season do you plan to go on your adventure?",
    difficulty: "easy",
    answers: [
      { content: "Spring - Cherry blossoms and mild temperatures", is_correct: false, metadata: "spring" },
      { content: "Summer - Warm weather and long days", is_correct: false, metadata: "summer" },
      { content: "Autumn - Fall colors and cooler temperatures", is_correct: false, metadata: "autumn" },
      { content: "Winter - Snow activities and winter landscapes", is_correct: false, metadata: "winter" }
    ]
  }
]

# Create questions and answers
questions_data.each do |question_data|
  question = adventure_quiz.questions.find_or_create_by!(
    content: question_data[:content],
    difficulty: question_data[:difficulty]
  )

  question_data[:answers].each do |answer_data|
    # For the adventure quiz, mark all answers as correct so there's no wrong answer
    question.answers.find_or_create_by!(
      content: answer_data[:content],
      is_correct: true
    )
  end
end

puts "Adventure Recommendation Quiz created successfully!"
