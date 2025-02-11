class Location < ApplicationRecord
  has_many :locations_adventures  # changed from locationsadventures
  has_many :adventures, through: :locations_adventures
  has_many :travel_plans
end
