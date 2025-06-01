# app/models/equipment_skill.rb
class EquipmentSkill < ApplicationRecord
  belongs_to :equipment
  belongs_to :skill
end
