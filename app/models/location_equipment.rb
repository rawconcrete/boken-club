class LocationEquipment < ApplicationRecord
  belongs_to :equipment
  belongs_to :location
end
