class TravelPlansController < ApplicationController
  before_action :authenticate_user!

  def index
    @travel_plans = current_user.travel_plans.includes(:location, :adventure)
  end

  def new
    @travel_plan = current_user.travel_plans.new
    @location = Location.find_by(id: params[:location_id])
    @adventure = Adventure.find_by(id: params[:adventure_id])
  end

  def create
    @travel_plan = current_user.travel_plans.build(travel_plan_params)
    if @travel_plan.save
      redirect_to @travel_plan, notice: 'Travel plan was successfully created.'
    else
      @location = Location.find_by(id: params[:travel_plan][:location_id])
      @adventure = Adventure.find_by(id: params[:travel_plan][:adventure_id])
      render :new
    end
  end

  def show
    @travel_plan = TravelPlan.includes(:location, :adventure).find(params[:id])
  end

  private

  def travel_plan_params
    params.require(:travel_plan).permit(:title, :content, :status, :location_id, :adventure_id)
  end
end
