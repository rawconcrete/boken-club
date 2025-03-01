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
