# app/models/travel_plan.rb
require_relative '../../lib/safety_warnings'

class TravelPlan < ApplicationRecord
  belongs_to :user
  has_many :travel_plans_locations, dependent: :destroy
  has_many :locations, through: :travel_plans_locations
  has_many :travel_plans_adventures, dependent: :destroy
  has_many :adventures, through: :travel_plans_adventures
  has_many :travel_plan_equipments, dependent: :destroy
  has_many :equipment, through: :travel_plan_equipments
  has_many :travel_plan_skills, dependent: :destroy
  has_many :skills, through: :travel_plan_skills

  validates :status, inclusion: { in: ['pending', 'completed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
  validates :title, presence: true

  # Generate safety warnings for this travel plan
  def safety_warnings
    SafetyWarnings::Generator.for_travel_plan(self)
  end

  # if we want equipment recommendations based on weather at some point
  # def recommended_equipment_for_weather
    # integrate with weather API based on location and dates
    # adjust equipment recommendations accordingly
  # end
end
