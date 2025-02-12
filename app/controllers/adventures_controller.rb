# content previously in controllers/activities_controller.rb has been merged into this file and activities_controller.rb has been deleted.
class AdventuresController < ApplicationController
  def index
    @adventures = Adventure.all
  end

  def show
    @adventure = Adventure.find(params[:id])
  end

  def search
    @adventures = ["Hiking", "Camping", "Rock Climbing", "Fishing", "Starting a Fire"]

    if params[:adventure].present?
      @locations = Location.where("adventure_name ILIKE ?", "%#{params[:adventure]}%").limit(5)
    else
      @locations = Location.limit(5)
    end
  end
end
