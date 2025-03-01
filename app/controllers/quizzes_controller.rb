# app/controllers/quizzes_controller.rb
class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_quiz, only: [:show, :take, :submit]

  def index
    @quizzes = Quiz.all

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
  end

  def show
    @questions_count = @quiz.questions.count
    @previous_attempts = current_user.quiz_attempts.where(quiz: @quiz).order(created_at: :desc) if user_signed_in?
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
