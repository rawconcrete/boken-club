# app/models/adventure.rb
class Adventure < ApplicationRecord
  has_many :locations_adventures, dependent: :destroy
  has_many :locations, through: :locations_adventures
  has_many :travel_plans_adventures, dependent: :destroy
  has_many :travel_plans, through: :travel_plans_adventures
  has_many :adventure_equipment, dependent: :destroy
  has_many :equipment, through: :adventure_equipment
end
