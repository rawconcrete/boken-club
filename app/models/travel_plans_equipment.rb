# app/models/travel_plans_equipment.rb
class TravelPlansEquipment < ApplicationRecord
  belongs_to :travel_plan
  belongs_to :equipment
end
