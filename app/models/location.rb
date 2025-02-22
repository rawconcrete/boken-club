# app/models/location.rb
class Location < ApplicationRecord
  has_many :locations_adventures
  has_many :adventures, through: :locations_adventures
  has_many :travel_plans_locations
  has_many :travel_plans, through: :travel_plans_locations
  has_many :location_equipments
  has_many :equipments, through: :location_equipments

  geocoded_by :full_address
  after_validation :geocode, if: :should_geocode?

  # Combine attributes to form a full address
  def full_address
    [name, city, prefecture, latitude, longitude].compact.join(', ')
  end
  # Condition to check if geocoding is needed
  def should_geocode?
    name_changed? || city_changed? || prefecture_changed? || latitude_changed? || longitude_changed?
  end
end
