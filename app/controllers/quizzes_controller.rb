# app/controllers/quizzes_controller.rb
class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_quiz, only: [:show, :take, :submit]

  def index
    @quizzes = Quiz.all.includes(:questions)

    # Filter by category if provided
    if params[:category].present?
      @quizzes = @quizzes.where(category: params[:category])
    end

    # Filter by difficulty if provided
    if params[:difficulty].present?
      @quizzes = @quizzes.where(difficulty: params[:difficulty])
    end

    # Filter by related entity if provided
    if params[:skill_id].present?
      @quizzes = @quizzes.for_skill(params[:skill_id])
      @skill = Skill.find_by(id: params[:skill_id])
    elsif params[:adventure_id].present?
      @quizzes = @quizzes.for_adventure(params[:adventure_id])
      @adventure = Adventure.find_by(id: params[:adventure_id])
    elsif params[:equipment_id].present?
      @quizzes = @quizzes.for_equipment(params[:equipment_id])
      @equipment = Equipment.find_by(id: params[:equipment_id])
    end

    # Get quiz attempts data for logged-in users
    if user_signed_in?
      # Get all completed attempts to ensure we have accurate scores
      completed_attempts = current_user.quiz_attempts
                                      .where(completed: true)
                                      .includes(:quiz_answers)

      # Get in-progress attempts
      in_progress_attempts = current_user.quiz_attempts
                                        .where(completed: false)

      # Create a hash of quiz_id => attempt data
      @quiz_attempts = {}

      # Process completed attempts and calculate scores
      completed_attempts.each do |attempt|
        # Calculate the score directly rather than using the stored value
        # This ensures accurate scores even if they weren't saved properly
        correct_count = attempt.quiz_answers.select(&:correct?).count
        total_count = attempt.quiz_answers.count
        score = total_count > 0 ? (correct_count.to_f / total_count * 100).round : 0

        # Only update the hash if this is the latest attempt for this quiz
        if !@quiz_attempts[attempt.quiz_id] ||
           attempt.created_at > @quiz_attempts[attempt.quiz_id][:date]
          @quiz_attempts[attempt.quiz_id] = {
            completed: true,
            score: score,
            date: attempt.created_at
          }
        end
      end

      # Add in-progress attempts that don't have a completed version
      in_progress_attempts.each do |attempt|
        # Only add if no completed attempt exists for this quiz
        if !@quiz_attempts.has_key?(attempt.quiz_id)
          @quiz_attempts[attempt.quiz_id] = {
            completed: false,
            score: nil,
            date: attempt.created_at
          }
        end
      end

      # Filter by completion status if requested
      if params[:completion].present?
        quiz_ids = case params[:completion]
                   when 'completed'
                     attempts.where(completed: true).pluck(:quiz_id)
                   when 'not_completed'
                     # Not completed includes both in progress and never attempted
                     completed_ids = attempts.where(completed: true).pluck(:quiz_id)
                     @quizzes.pluck(:id) - completed_ids
                   end
        @quizzes = @quizzes.where(id: quiz_ids) if quiz_ids.present?
      end
    end
  end

  def show
    @questions_count = @quiz.questions.count

    # Make sure we handle the case where user is not logged in
    if user_signed_in?
      # Handle the case where the relationship might not exist yet
      begin
        @previous_attempts = current_user.quiz_attempts.where(quiz: @quiz).order(created_at: :desc)
      rescue NoMethodError
        # If the method doesn't exist yet (migration might not have run)
        @previous_attempts = []
      end
    end
  end

  def take
    # Create a new quiz attempt or get existing in-progress attempt
    @quiz_attempt = QuizAttempt.find_or_create_by(
      user: current_user,
      quiz: @quiz,
      completed: false
    )

    # Get questions for the quiz
    @questions = @quiz.questions.includes(:answers)

    # Get previously answered questions
    @answered_questions = @quiz_attempt.quiz_answers.pluck(:question_id)

    # Filter out answered questions
    @unanswered_questions = @questions.reject { |q| @answered_questions.include?(q.id) }

    if @unanswered_questions.empty?
      # If all questions are answered, complete the quiz
      @quiz_attempt.update(completed: true, score: @quiz_attempt.score)
      redirect_to quiz_result_path(@quiz_attempt)
    else
      # Get the next unanswered question
      @question = @unanswered_questions.first
      @answers = @question.answers
    end
  end

  def submit
    @quiz_attempt = current_user.quiz_attempts.find_by(quiz: @quiz, completed: false)

    if @quiz_attempt.nil?
      redirect_to quizzes_path, alert: "Quiz attempt not found"
      return
    end

    @question = @quiz.questions.find_by(id: params[:question_id])
    @answer = @question.answers.find_by(id: params[:answer_id]) if @question

    if @question.nil? || @answer.nil?
      redirect_to take_quiz_path(@quiz), alert: "Invalid question or answer"
      return
    end

    # Save the answer
    @quiz_answer = QuizAnswer.create(
      quiz_attempt: @quiz_attempt,
      question: @question,
      answer: @answer
    )

    # Check if all questions have been answered
    if @quiz_attempt.quiz_answers.count == @quiz.questions.count
      @quiz_attempt.update(completed: true, score: @quiz_attempt.score)
      redirect_to quiz_result_path(@quiz_attempt)
    else
      redirect_to take_quiz_path(@quiz)
    end
  end

  def result
    @quiz_attempt = QuizAttempt.find(params[:id])
    @quiz = @quiz_attempt.quiz

    # If this is the adventure finder quiz, redirect to the recommendation page
    if @quiz.title == "Find Your Perfect Adventure"
      redirect_to adventure_recommendation_path(@quiz_attempt) and return
    end

    # For standard quizzes, proceed with the normal result display
    @score = @quiz_attempt.score
    @quiz_answers = @quiz_attempt.quiz_answers.includes(:question, :answer)
  end



  private

  def adventure_recommendation
    @quiz_attempt = QuizAttempt.find(params[:id])
    @quiz = @quiz_attempt.quiz

    if @quiz.title != "Find Your Perfect Adventure"
      redirect_to quiz_result_path(@quiz_attempt)
      return
    end

    # Extract answers from the quiz attempt
    @answers = []
    @quiz_attempt.quiz_answers.includes(:question, :answer).each do |qa|
      @answers << qa.answer.content.split(" - ").first.downcase
    end

    # Calculate the recommended adventure
    @recommended_adventure = calculate_adventure_recommendation(@answers)
  end


  def calculate_adventure_recommendation(answers)
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

    # Activity level (first question)
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

    # Environment (second question)
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

    # Experience level (third question)
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

    # Duration (fourth question)
    case answers[3]
    when "day"
      scores[:hiking] += 2
      scores[:cultural_tours] += 3
      scores[:climbing] += 1
      scores[:camping] -= 3
    when "full"
      scores[:hiking] += 3
      scores[:climbing] += 3
      scores[:water_activities] += 3
      scores[:cultural_tours] += 2
    when "multi"
      scores[:camping] += 5
      scores[:hiking] += 3
      scores[:winter_sports] += 2
    end

    # Season (fifth question)
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

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end
end
