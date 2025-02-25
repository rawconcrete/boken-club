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

  scope :for_adventure, ->(adventure_ids) {
    return none if adventure_ids.blank?
    joins(:adventure_equipments)
      .where(adventure_equipments: { adventure_id: adventure_ids })
      .distinct
  }

  # combined equipment recommendations
  def self.recommended_for(location_ids: nil, adventure_ids: nil, date: nil)
    Rails.logger.debug "EQUIPMENT RECOMMENDATION REQUEST ----"
    Rails.logger.debug "Location IDs: #{location_ids.inspect}"
    Rails.logger.debug "Adventure IDs: #{adventure_ids.inspect}"
    Rails.logger.debug "Date: #{date.inspect}"

    # get matching equipment
    matches = []

    # add location-specific equipment
    if location_ids.present?
      location_equipment = for_location(location_ids)
      if location_equipment.exists?
        matches << location_equipment.pluck(:id)
        Rails.logger.debug "Location equipment count: #{location_equipment.count}"
      end
    end

    # add adventure-specific equipment
    if adventure_ids.present?
      adventure_equipment = for_adventure(adventure_ids)
      if adventure_equipment.exists?
        matches << adventure_equipment.pluck(:id)
        Rails.logger.debug "Adventure equipment count: #{adventure_equipment.count}"
      end
    end

    # add seasonal equipment
    if date.present?
      seasonal_equipment = for_season(date)
      if seasonal_equipment.exists?
        matches << seasonal_equipment.pluck(:id)
        Rails.logger.debug "Seasonal equipment count: #{seasonal_equipment.count}"
      end
    end

    # filter to matching equipment if we have matches
    if matches.any?
      # flatten all matched IDs into a single array
      matching_ids = matches.flatten.uniq
      Rails.logger.debug "Total unique matches: #{matching_ids.size}"
      # return only equipment with those IDs
      result = where(id: matching_ids)
      Rails.logger.debug "EQUIPMENT RESULT: #{result.count} items, IDs: #{result.pluck(:id).inspect}"
      result
    else
      # if no matches, return a subset of general equipment
      basic =     where(name: ["First Aid Kit", "Water Bottle", "Backpack (30-40L)"])
      Rails.logger.debug "BASIC EQUIPMENT: #{basic.count} items, IDs: #{basic.pluck(:id).inspect}"
      basic
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
