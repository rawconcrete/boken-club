# app/models/quiz.rb
class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy
  has_many :users, through: :quiz_attempts

  validates :title, presence: true
  validates :description, presence: true

  # find quizzes related to specific skills, adventures, or equipment
  scope :for_skill, ->(skill_id) { where(skill_id: skill_id) }
  scope :for_adventure, ->(adventure_id) { where(adventure_id: adventure_id) }
  scope :for_equipment, ->(equipment_id) { where(equipment_id: equipment_id) }

  # get general wilderness quizzes
  scope :general, -> { where(skill_id: nil, adventure_id: nil, equipment_id: nil) }
end
