class TravelPlanEquipment < ApplicationRecord
  belongs_to :travel_plan
  belongs_to :equipment
end
