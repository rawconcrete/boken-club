# app/models/equipment.rb
class Equipment < ApplicationRecord
  # existing associations
  has_many :equipment_locations
  has_many :locations, through: :equipment_locations
  has_many :equipment_adventures
  has_many :adventures, through: :equipment_adventures
  has_many :user_equipments
  has_many :users, through: :user_equipments
  has_many :equipment_tips
  has_many :tips, through: :equipment_tips

  # new associations for travel plans
  has_many :travel_plan_equipments
  has_many :travel_plans, through: :travel_plan_equipments

  validates :name, presence: true
  validates :description, presence: true
end
