# app/models/travel_plan.rb
class TravelPlan < ApplicationRecord
  belongs_to :adventure, optional: true
  belongs_to :location, optional: true
  belongs_to :user

  validates :status, inclusion: { in: ['pending', 'completed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
end
