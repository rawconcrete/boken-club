class LocationsAdventure < ApplicationRecord
  belongs_to :adventure
  belongs_to :location
end
