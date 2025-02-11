# app/controllers/travel_plans_controller.rb
class TravelPlansController < ApplicationController
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
