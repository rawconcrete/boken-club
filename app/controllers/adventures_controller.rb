class AdventuresController < ApplicationController
  def index
    @adventures = Adventure.all

    # Search by query
    if params[:query].present?
      @adventures = @adventures.where(
        "name ILIKE ? OR details ILIKE ? OR tips ILIKE ? OR warnings ILIKE ?",
        "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%"
      )
    end

    # Filter by locations (for Stimulus requests)
    if params[:location_ids].present?
      location_ids = params[:location_ids].split(',').map(&:to_i)
      @adventures = @adventures.joins(:locations)
                               .where(locations: { id: location_ids })
                               .distinct
    end

    respond_to do |format|
      format.html # Normal HTML response
      format.json { render json: @adventures.as_json(only: [:id, :name, :details]) }
    end
  end

  def show
    @adventure = Adventure.find_by(id: params[:id])

    return redirect_to adventures_path, alert: "Adventure not found" if @adventure.nil?

    respond_to do |format|
      format.html # Renders default HTML view
      format.json { render json: @adventure.as_json(only: [:id, :name, :details, :tips, :warnings]) }
    end
  end
end
