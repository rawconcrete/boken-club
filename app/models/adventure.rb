# app/models/adventure.rb
class Adventure < ApplicationRecord
  has_many :locations_adventures
  has_many :locations, through: :locations_adventures
  has_many :travel_plans_adventures
  has_many :travel_plans, through: :travel_plans_adventures
end
