class TravelPlan < ApplicationRecord
  belongs_to :adventure
  belongs_to :location
  belongs_to :user

  validates :status, inclusion: { in: ['pending', 'completed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
end
