class Location < ApplicationRecord
  has_many :locationsadventures
  has_many :adventures, through: :locations_adventures
  has_many :travel_plans
end
