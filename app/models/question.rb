# app/models/question.rb
class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, dependent: :destroy

  validates :content, presence: true
  validates :difficulty, inclusion: { in: %w(easy medium hard) }

  # define which answers are correct
  def correct_answers
    answers.where(is_correct: true)
  end

  # check if a specific answer is correct
  def correct_answer?(answer_id)
    answers.where(id: answer_id, is_correct: true).exists?
  end
end
