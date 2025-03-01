# app/models/answer.rb
class Answer < ApplicationRecord
  belongs_to :question

  validates :content, presence: true
  validates :is_correct, inclusion: { in: [true, false] }
end
