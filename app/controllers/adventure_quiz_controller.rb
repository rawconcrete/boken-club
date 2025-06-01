# app/controllers/adventure_quiz_controller.rb
class AdventureQuizController < ApplicationController
  skip_before_action :authenticate_user!, only: [:start, :question, :result]

  def start
    # Initialize a new adventure quiz session
    session[:adventure_quiz] = {
      answers: [],
      current_question: 0
    }

    # Redirect to the first question
    redirect_to adventure_quiz_question_path
  end

  def question
    # Retrieve or initialize the quiz session
    @session = session[:adventure_quiz] || { answers: [], current_question: 0 }

    # Get questions for the adventure recommendation quiz
    @questions = adventure_quiz_questions

    # Check if we've reached the end of the quiz
    if @session[:current_question] >= @questions.length
      redirect_to adventure_quiz_result_path
      return
    end

    # Get the current question
    @question = @questions[@session[:current_question]]

    # Store the current session
    session[:adventure_quiz] = @session
  end

  def answer
    # Retrieve the quiz session
    @session = session[:adventure_quiz]

    # Get all the questions
    questions = adventure_quiz_questions

    # Add the selected answer to the answers array
    @session[:answers] << params[:option]

    # Move to the next question
    @session[:current_question] += 1

    # Store the updated session
    session[:adventure_quiz] = @session

    # Redirect to the next question or result
    if @session[:current_question] >= questions.length
      redirect_to adventure_quiz_result_path
    else
      redirect_to adventure_quiz_question_path
    end
  end

  def result
    # Retrieve the quiz session
    @session = session[:adventure_quiz]

    # Get the answers from the session
    answers = @session[:answers]

    # Calculate the recommended adventure
    @recommended_adventure = calculate_recommendation(answers)

    # Reset the quiz session
    session[:adventure_quiz] = nil
  end

  private

  def adventure_quiz_questions
    [
      {
        question: "What activity level do you prefer?",
        options: [
          { value: "active", text: "Active - I want to challenge myself physically" },
          { value: "moderate", text: "Moderate - I enjoy moving but don't want it too strenuous" },
          { value: "relaxed", text: "Relaxed - I prefer a more laid back experience" }
        ]
      },
      {
        question: "What type of environment interests you most?",
        options: [
          { value: "mountains", text: "Mountains - I love high peaks and challenging terrain" },
          { value: "forests", text: "Forests - I enjoy tree cover and wildlife" },
          { value: "water", text: "Water - I'm drawn to lakes, rivers, or oceans" },
          { value: "cultural", text: "Cultural - I'm interested in historic or cultural sites" }
        ]
      },
      {
        question: "How much experience do you have with outdoor activities?",
        options: [
          { value: "beginner", text: "Beginner - I'm new to outdoor adventures" },
          { value: "intermediate", text: "Intermediate - I have some experience" },
          { value: "advanced", text: "Advanced - I'm very experienced in outdoor activities" }
        ]
      },
      {
        question: "How long would you like your adventure to be?",
        options: [
          { value: "day", text: "Day trip - Just a few hours" },
          { value: "full_day", text: "Full day - From morning to evening" },
          { value: "multi_day", text: "Multi-day - An overnight or longer experience" }
        ]
      },
      {
        question: "What season do you plan to go on your adventure?",
        options: [
          { value: "spring", text: "Spring - Cherry blossoms and mild temperatures" },
          { value: "summer", text: "Summer - Warm weather and long days" },
          { value: "autumn", text: "Autumn - Fall colors and cooler temperatures" },
          { value: "winter", text: "Winter - Snow activities and winter landscapes" }
        ]
      }
    ]
  end

  def calculate_recommendation(answers)
    # This is a simplified recommendation algorithm
    # In a real implementation, you would likely use more sophisticated matching

    # Initialize scores for different adventure types
    scores = {
      hiking: 0,
      climbing: 0,
      camping: 0,
      water_activities: 0,
      cultural_tours: 0,
      winter_sports: 0
    }

    # Score based on activity level
    case answers[0]
    when "active"
      scores[:hiking] += 3
      scores[:climbing] += 4
      scores[:winter_sports] += 3
    when "moderate"
      scores[:hiking] += 4
      scores[:camping] += 3
      scores[:water_activities] += 3
      scores[:cultural_tours] += 2
    when "relaxed"
      scores[:camping] += 4
      scores[:cultural_tours] += 4
      scores[:water_activities] += 2
    end

    # Score based on environment
    case answers[1]
    when "mountains"
      scores[:hiking] += 4
      scores[:climbing] += 4
      scores[:winter_sports] += 3
    when "forests"
      scores[:hiking] += 3
      scores[:camping] += 4
    when "water"
      scores[:water_activities] += 5
      scores[:camping] += 2
    when "cultural"
      scores[:cultural_tours] += 5
      scores[:hiking] += 1
    end

    # Score based on experience level
    case answers[2]
    when "beginner"
      scores[:hiking] += 3
      scores[:camping] += 3
      scores[:cultural_tours] += 4
      scores[:water_activities] -= 1
      scores[:climbing] -= 2
      scores[:winter_sports] -= 1
    when "intermediate"
      scores[:hiking] += 3
      scores[:camping] += 3
      scores[:water_activities] += 3
      scores[:climbing] += 2
      scores[:winter_sports] += 2
    when "advanced"
      scores[:climbing] += 4
      scores[:winter_sports] += 3
      scores[:hiking] += 2
      scores[:water_activities] += 2
    end

    # Score based on duration
    case answers[3]
    when "day"
      scores[:hiking] += 2
      scores[:cultural_tours] += 3
      scores[:climbing] += 1
      scores[:camping] -= 3
    when "full_day"
      scores[:hiking] += 3
      scores[:climbing] += 3
      scores[:water_activities] += 3
      scores[:cultural_tours] += 2
    when "multi_day"
      scores[:camping] += 5
      scores[:hiking] += 3
      scores[:winter_sports] += 2
    end

    # Score based on season
    case answers[4]
    when "winter"
      scores[:winter_sports] += 5
      scores[:hiking] -= 1
      scores[:water_activities] -= 3
    when "summer"
      scores[:water_activities] += 4
      scores[:camping] += 3
      scores[:hiking] += 2
    when "autumn"
      scores[:hiking] += 4
      scores[:cultural_tours] += 3
      scores[:camping] += 2
    when "spring"
      scores[:hiking] += 3
      scores[:cultural_tours] += 3
      scores[:camping] += 2
    end

    # Find the highest scoring activity type
    top_activity = scores.max_by { |k, v| v }[0]

    # Map activity type to specific adventures from the database
    adventures = Adventure.all

    case top_activity
    when :hiking
      adventure = adventures.find { |a| a.name.downcase.include?("hik") || a.name.downcase.include?("trek") }
    when :climbing
      adventure = adventures.find { |a| a.name.downcase.include?("climb") || a.name.downcase.include?("boulder") }
    when :camping
      adventure = adventures.find { |a| a.name.downcase.include?("camp") }
    when :water_activities
      adventure = adventures.find { |a| a.name.downcase.include?("kayak") || a.name.downcase.include?("raft") || a.name.downcase.include?("lake") }
    when :cultural_tours
      adventure = adventures.find { |a| a.name.downcase.include?("castle") || a.name.downcase.include?("tour") || a.name.downcase.include?("shrine") }
    when :winter_sports
      adventure = adventures.find { |a| a.name.downcase.include?("ski") || a.name.downcase.include?("snow") }
    end

    # Fallback if no specific adventure found
    adventure ||= Adventure.first

    adventure
  end
end
