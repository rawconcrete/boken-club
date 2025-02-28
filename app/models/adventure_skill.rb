class AdventureSkill < ApplicationRecord
  belongs_to :adventure
  belongs_to :skill
end
