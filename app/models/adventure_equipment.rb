class AdventureEquipment < ApplicationRecord
  belongs_to :adventure
  belongs_to :equipment
end
