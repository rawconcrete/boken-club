# adventure.rb
class Adventure < ApplicationRecord
  has_many :locations_adventures
  has_many :locations, through: :locations_adventures
end
