# app/controllers/travel_plans_controller.rb
class TravelPlansController < ApplicationController
  def index
    @travel_plans = current_user.travel_plans.includes(:location, :adventure)
  end

  def new
    @travel_plan = TravelPlan.new
    @location = Location.find(params[:location_id]) if params[:location_id]
    @adventure = Adventure.find(params[:adventure_id]) if params[:adventure_id]
  end

  def create
    @travel_plan = current_user.travel_plans.build(travel_plan_params)
    if @travel_plan.save
      redirect_to @travel_plan, notice: 'Travel plan was successfully created.'
    else
      @location = Location.find(params[:location_id]) if params[:location_id]
      @adventure = Adventure.find(params[:adventure_id]) if params[:adventure_id]
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
