# model file should be travelplan, not travel_plans. the table will automatically become travel_plans.
class TravelPlan < ApplicationRecord
  belongs_to :adventure, optional: true
  belongs_to :location, optional: true
  belongs_to :user

  validates :status, inclusion: { in: ['pending', 'completed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
end
