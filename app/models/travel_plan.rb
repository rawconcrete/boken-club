class TravelPlan < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :user

  has_many :travel_plans_adventures
  has_many :adventures, through: :travel_plans_adventures

  validates :status, inclusion: { in: ['pending', 'completed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
end
