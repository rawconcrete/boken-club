class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
  end

  def search
    @locations = Location.where("name LIKE ?", "%#{params[:query]}%")
  end
