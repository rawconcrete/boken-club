# app/controllers/locations_controller.rb
class LocationsController < ApplicationController
  def index
    @locations = if params[:query].present?
                   Location.where("name ILIKE ? OR city ILIKE ? OR prefecture ILIKE ?",
                                 "%#{params[:query]}%",
                                 "%#{params[:query]}%",
                                 "%#{params[:query]}%")
                 else
                   Location.all
                 end

      respond_to do |format|
      format.html
      format.json { render json: @adventures }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("adventures-list", partial: "adventures/list", locals: { adventures: @adventures }) }
    end
  end
end
