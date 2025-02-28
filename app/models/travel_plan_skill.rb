# app/models/travel_plan_skill.rb
class TravelPlanSkill < ApplicationRecord
  belongs_to :travel_plan
  belongs_to :skill
end
