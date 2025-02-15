class AdventuresController < ApplicationController
  def index
    @adventures = Adventure.all

    respond_to do |format|
      format.html
      format.json do
        if params[:location_ids].present?
          location_ids = params[:location_ids].split(',')
          @adventures = Adventure.joins(:locations)
                               .where(locations: { id: location_ids })
                               .distinct
        end

        adventures = @adventures.map do |adventure|
          {
            id: adventure.id,
            name: adventure.name,
            details: adventure.details
          }
        end

        render json: adventures
      end
    end
  end
end
