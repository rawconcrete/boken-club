# app/models/adventure.rb
class Adventure < ApplicationRecord
  has_many :locations_adventures
  has_many :locations, through: :locations_adventures
  has_many :travel_plans_adventures
  has_many :travel_plans, through: :travel_plans_adventures
  has_many :adventure_equipments, dependent: :destroy
  has_many :equipment, through: :adventure_equipments

  # add the skill associations
  has_many :adventure_skills, dependent: :destroy
  has_many :skills, through: :adventure_skills
end
