# app/models/location.rb
class Location < ApplicationRecord
  has_many :locations_adventures
  has_many :adventures, through: :locations_adventures
  has_many :travel_plans_locations
  has_many :travel_plans, through: :travel_plans_locations
  has_many :location_equipments, dependent: :destroy
  has_many :equipment, through: :location_equipments
  has_many :location_skills, dependent: :destroy
  has_many :skills, through: :location_skills

  geocoded_by :full_address
  after_validation :geocode, if: :should_geocode?

  # combine attributes to form a full address
  def full_address
    [name, city, prefecture].compact.join(', ')
  end
  # condition to check if geocoding is needed
  def should_geocode?
    will_save_change_to_city? || city_changed? || prefecture_changed?
  end
end
