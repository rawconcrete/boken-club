class ActivitiesController < ApplicationController
  def search
    # Placeholder activities for demonstration
    @activities = ["Hiking", "Camping", "Rock Climbing", "Fishing", "Starting a Fire"]

    # Get locations based on the selected activity
    if params[:activity].present?
      @locations = Location.where("activity_name ILIKE ?", "%#{params[:activity]}%").limit(5) # Case-insensitive search
    else
      @locations = Location.limit(5) # Show first 5 locations if no activity is selected
    end
  end
end
