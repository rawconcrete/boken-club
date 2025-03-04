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
    @score = @quiz_attempt.score
    @quiz_answers = @quiz_attempt.quiz_answers.includes(:question, :answer)
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end
end
