class TravelPlansController < ApplicationController
  def index
    @travel_plans = current_user.travel_plans
  end

  def new
  end

  def create
  end

  def show
    @travel_plan = TravelPlan.find(params[:id])
    @location = @travel_plan.location
    @adventure = @travel_plan.adventure
  end
end
