class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
  end

  # def edit
  # end

  # def update
  # end
end
