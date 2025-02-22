class AdventuresController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  def index
    @adventures = Adventure.all

    @adventures = if params[:query].present?
      Adventure.where("name ILIKE ? OR details ILIKE ? OR tips ILIKE ? OR warnings ILIKE ?",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%")
    else
      Adventure.all
    end

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

  def show
    @adventure = Adventure.find_by(id: params[:id])

    if @adventure.nil?
      redirect_to adventures_path, alert: "Adventure not found"
    else
      respond_to do |format|
        format.html
        format.json { render json: @adventure }
      end
    end
  end

end
