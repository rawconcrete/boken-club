class TravelPlan < ApplicationRecord
  belongs_to :user
  has_many :travel_plans_locations, dependent: :destroy
  has_many :locations, through: :travel_plans_locations
  has_many :travel_plans_adventures, dependent: :destroy
  has_many :adventures, through: :travel_plans_adventures
  has_many :adventure_travel_plan_disclaimers
  has_many :disclaimer_adventures, through: :adventure_travel_plan_disclaimers, source: :adventure


  validates :status, inclusion: { in: ['pending', 'completed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
  validates :title, presence: true

end
