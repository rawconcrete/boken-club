# app/controllers/locations_controller.rb
class LocationsController < ApplicationController
  def index
    if params[:query].present?
      @locations = Location.where("name ILIKE ? OR city ILIKE ? OR prefecture ILIKE ?",
                                "%#{params[:query]}%",
                                "%#{params[:query]}%",
                                "%#{params[:query]}%")
    else
      @locations = Location.all
    end
  end

  def show
    @location = Location.find(params[:id])
  end
end
