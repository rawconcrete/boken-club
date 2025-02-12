# app/controllers/adventures_controller.rb
class AdventuresController < ApplicationController
  def index
    @adventures = if params[:query].present?
                   Adventure.where("name ILIKE ?", "%#{params[:query]}%")
                 else
                   Adventure.all
                 end

    respond_to do |format|
      format.html
      format.json do
        adventures = if params[:location_ids].present?
          location_ids = params[:location_ids].split(',')
          @adventures.map do |adventure|
            {
              id: adventure.id,
              name: adventure.name,
              details: adventure.details,
              available: adventure.locations.where(id: location_ids).exists?
            }
          end
        else
          @adventures.map { |a| { id: a.id, name: a.name, details: a.details, available: true } }
        end
        render json: adventures
      end
      format.turbo_stream
    end
  end

  def show
    @adventure = Adventure.find_by(id: params[:id])

    if @adventure.nil?
      redirect_to adventures_path, alert: "Adventure not found"
      return
    end

    respond_to do |format|
      format.html
      format.json {
        render json: {
          id: @adventure.id,
          name: @adventure.name,
          details: @adventure.details,
          available_locations: @adventure.location_ids
        }
      }
    end
  end
end
