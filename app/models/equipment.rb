# app/models/equipment.rb
class Equipment < ApplicationRecord
  # use singular table name explicitly since 'equipment' is an uncountable noun
  self.table_name = "equipment"

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
    base_scope = all  # start with all equipment

    # get matching equipment
    matches = []

    # add location-specific equipment
    if location_ids.present?
      location_equipment = for_location(location_ids)
      matches << location_equipment.pluck(:id) if location_equipment.exists?
    end

    # add adventure-specific equipment
    if adventure_ids.present?
      adventure_equipment = for_adventure(adventure_ids)
      matches << adventure_equipment.pluck(:id) if adventure_equipment.exists?
    end

    # add seasonal equipment
    if date.present?
      seasonal_equipment = for_season(date)
      matches << seasonal_equipment.pluck(:id) if seasonal_equipment.exists?
    end

    # filter to matching equipment if we have matches
    if matches.any?
      # flatten all matched IDs into a single array
      matching_ids = matches.flatten.uniq
      # return only equipment with those IDs
      where(id: matching_ids)
    else
      # if no matches, return a subset of general equipment
      where(category: ["essential", "safety"]).or(where(name: ["Water Bottle", "First Aid Kit"]))
    end
  end

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
