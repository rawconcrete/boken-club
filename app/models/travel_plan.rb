# app/models/travel_plan.rb
class TravelPlan < ApplicationRecord
  belongs_to :user
  has_many :travel_plans_locations, dependent: :destroy
  has_many :locations, through: :travel_plans_locations
  has_many :travel_plans_adventures, dependent: :destroy
  has_many :adventures, through: :travel_plans_adventures
  has_many :travel_plans_equipment, dependent: :destroy
  has_many :equipment, through: :travel_plans_equipment

  validates :status, inclusion: { in: ['pending', 'completed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
  validates :title, presence: true

  scope :in_progress, -> { where(status: 'pending') }
end
