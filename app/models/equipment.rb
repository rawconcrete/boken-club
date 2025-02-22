# app/models/equipment.rb
class Equipment < ApplicationRecord
  # Update these lines to match the actual model names
  has_many :location_equipments
  has_many :locations, through: :location_equipments
  has_many :adventure_equipments
  has_many :adventures, through: :adventure_equipments

  # Keep these existing associations
  has_many :user_equipments
  has_many :users, through: :user_equipments
  has_many :equipment_tips
  has_many :tips, through: :equipment_tips

  # New association for travel plans
  has_many :travel_plan_equipments
  has_many :travel_plans, through: :travel_plan_equipments

  validates :name, presence: true
  validates :description, presence: true

  # add seasonal scope
  scope :for_season, ->(date) {
    return all unless date
    season = get_season(date)
    where(recommended_seasons: season)
  }

  scope :for_location, ->(location_ids) {
    return all if location_ids.blank?
    joins(:location_equipments)
      .where(location_equipments: { location_id: location_ids })
      .distinct
  }

  scope :for_adventure, ->(adventure_ids) {
    return all if adventure_ids.blank?
    joins(:adventure_equipments)
      .where(adventure_equipments: { adventure_id: adventure_ids })
      .distinct
  }

  # if we want equipment caching
  # def self.cached_recommendations(location_ids, adventure_ids, date)
    # Rails.cache.fetch(["equipment", location_ids, adventure_ids, date], expires_in: 1.hour) do
      # equipment fetching logic
    # end
  # end

  # if we want equipment categories and priority levels
  #
  # enum category: [:essential, :recommended, :optional]
  # enum season_priority: [:low, :medium, :high]

  # scope :essential_for_conditions, ->(conditions) {
    # where(category: :essential)
      # .where(conditions: conditions)
      # .order(season_priority: :desc)
  # }
end
