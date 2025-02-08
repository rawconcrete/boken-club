# adventure.rb
class Adventure < ApplicationRecord
  belongs_to :location

  has_many :locations_adventures
  has_many :locations, through: :locations_adventures
end
