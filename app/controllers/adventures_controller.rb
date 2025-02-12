class AdventuresController < ApplicationController
  def index
    if params[:query].present?
      @adventures = Adventure.where("name ILIKE ?", "%#{params[:query]}%")
      @locations = Location.where("adventure_name ILIKE ?", "%#{params[:query]}%").limit(5)
    else
      @adventures = Adventure.all
      @locations = Location.limit(5)
    end
  end

  def show
    @adventure = Adventure.find(params[:id])
  end
end
