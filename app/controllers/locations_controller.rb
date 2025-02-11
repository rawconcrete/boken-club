class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
    @adventures = @location.adventures  # removed includes
  end

  def search
    @locations = Location.where("LOWER(name) LIKE ?", "%#{params[:query].downcase}%")
  end
end
