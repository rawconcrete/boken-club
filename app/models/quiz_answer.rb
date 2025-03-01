# app/models/quiz_answer.rb
class QuizAnswer < ApplicationRecord
  belongs_to :quiz_attempt
  belongs_to :question
  belongs_to :answer

  def correct?
    answer.is_correct
  end
end
