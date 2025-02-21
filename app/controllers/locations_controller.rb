# app/controllers/locations_controller.rb
class LocationsController < ApplicationController
  def index
    @locations = if params[:query].present?
      Location.where("name ILIKE ? OR city ILIKE ? OR prefecture ILIKE ? OR details ILIKE ?",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%")
    else
      Location.all
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
      redirect_to locations_path, alert: "Location not found"
      return
    end

    respond_to do |format|
      format.html
      format.json {
        render json: {
          id: @location.id,
          name: @location.name,
          city: @location.city,
          prefecture: @location.prefecture,
          equipment: @location.equipment.map { |e| { id: e.id, name: e.name } }
        }
      }
    end
  end
end
