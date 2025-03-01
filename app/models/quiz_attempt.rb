# app/models/quiz_attempt.rb
class QuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  has_many :quiz_answers, dependent: :destroy

  def score
    return 0 if quiz_answers.empty?

    correct_count = quiz_answers.select(&:correct?).count
    total_count = quiz_answers.count

    (correct_count.to_f / total_count * 100).round
  end

  def completed?
    # Check if all questions have been answered
    quiz.questions.count == quiz_answers.count
  end
end
