# app/models/location.rb
class Location < ApplicationRecord
  has_many :locations_adventures
  has_many :adventures, through: :locations_adventures
  has_many :travel_plans_locations
  has_many :travel_plans, through: :travel_plans_locations

  # for equipment:
  has_many :location_equipment
  has_many :equipment, through: :location_equipment
end
