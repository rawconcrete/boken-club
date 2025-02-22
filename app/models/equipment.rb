# app/models/equipment.rb
class Equipment < ApplicationRecord
  # update to match the actual model names
  has_many :location_equipments
  has_many :locations, through: :location_equipments
  has_many :adventure_equipments
  has_many :adventures, through: :adventure_equipments

  # existing associations
  has_many :user_equipments
  has_many :users, through: :user_equipments
  has_many :equipment_tips
  has_many :tips, through: :equipment_tips

  # new association for travel plans
  has_many :travel_plan_equipments
  has_many :travel_plans, through: :travel_plan_equipments

  validates :name, presence: true
  validates :description, presence: true

  # season-specific scopes
  scope :for_season, ->(date) {
    return none unless date
    season = get_season(date)
    season_field = "#{season}_recommended"
    where(season_field => true)
  }

  # location-specific equipment
  scope :for_location, ->(location_ids) {
    return none if location_ids.blank?
    joins(:location_equipments)
      .where(location_equipments: { location_id: location_ids })
      .distinct
  }

  # adventure-specific equipment
  scope :for_adventure, ->(adventure_ids) {
    return none if adventure_ids.blank?
    joins(:adventure_equipments)
      .where(adventure_equipments: { adventure_id: adventure_ids })
      .distinct
  }

  # combined equipment recommendations
  def self.recommended_for(location_ids: nil, adventure_ids: nil, date: nil)
    base_scope = all  # Start with all equipment

    # filter by location if provided
    if location_ids.present?
      location_equipment = for_location(location_ids)
      base_scope = base_scope.merge(location_equipment) if location_equipment.exists?
    end

    # filter by adventure if provided
    if adventure_ids.present?
      adventure_equipment = for_adventure(adventure_ids)
      base_scope = base_scope.merge(adventure_equipment) if adventure_equipment.exists?
    end

    # filter by season if date provided
    if date.present?
      seasonal_equipment = for_season(date)
      base_scope = base_scope.merge(seasonal_equipment) if seasonal_equipment.exists?
    end

    base_scope.distinct
  end

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

  private

  def self.get_season(date)
    return nil unless date

    month = date.month
    case month
    when 12, 1, 2
      'winter'
    when 3, 4, 5
      'spring'
    when 6, 7, 8
      'summer'
    when 9, 10, 11
      'autumn'
    end
  end
end
