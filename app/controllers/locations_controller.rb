class LocationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @locations = if params[:query].present?
      Location.where("name ILIKE ? OR city ILIKE ? OR prefecture ILIKE ? OR details ILIKE ? OR tips ILIKE ? OR warnings ILIKE ? OR adventure_name ILIKE ?",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%")
    else
      Location.all
    end

    puts "Locations: #{@locations.inspect}" # Debugging: Check the locations
    @markers = @locations.geocoded.map do |location|
      {
        name: location.name,
        city: location.city,
        prefecture: location.prefecture,
        lat: location.latitude,
        lng: location.longitude
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @locations }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("locations-list", partial: "locations/list", locals: { locations: @locations }) }
    end
  end

  def show
    @location = Location.find_by(id: params[:id])

    if @location.nil?
      respond_to do |format|
        format.html { redirect_to locations_path, alert: "Location not found" }
        format.json { render json: { error: "Location not found" }, status: :not_found }
      end
      return
    end

    @markers = [
      {
        lat: @location.latitude,
        lng: @location.longitude
      }
    ]

    respond_to do |format|
      format.html
      format.json {
        render json: {
          id: @location.id,
          name: @location.name,
          city: @location.city,
          prefecture: @location.prefecture,
          lat: @location.latitude,
          lng: @location.longitude
        }
      }
    end
  end
end
