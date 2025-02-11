class TravelPlansController < ApplicationController
  def index
    @travel_plans = current_user.travel_plans
  end

  def new
    @travel_plan = TravelPlan.new
  end

  def create
    @travel_plan = current_user.travel_plans.build(travel_plan_params)
    if @travel_plan.save
      redirect_to @travel_plan, notice: 'Travel plan was successfully created.'
    else
      render :new
    end
  end

  def show
    @travel_plan = TravelPlan.find(params[:id])
    @location = @travel_plan.location
    @adventure = @travel_plan.adventure
  end

private

  def travel_plan_params
    params.require(:travel_plan).permit(:title, :content, :status, :location_id, :adventure_id)
  end
end
# comment for push
