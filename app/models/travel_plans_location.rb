class TravelPlansLocation < ApplicationRecord
  belongs_to :travel_plan
  belongs_to :location
end
