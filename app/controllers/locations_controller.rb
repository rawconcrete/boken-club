#locations_controller.rb
class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
    @adventures = @location.adventures.includes(:locations_adventures)
  end

  def search
    @locations = Location.where("name LIKE ?", "%#{params[:query]}%")
  end
end
