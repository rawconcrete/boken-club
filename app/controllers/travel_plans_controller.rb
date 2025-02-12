# app/controllers/travel_plans_controller.rb
class TravelPlansController < ApplicationController
  before_action :authenticate_user!

  def index
    @travel_plans = current_user.travel_plans.includes(:locations, :adventures)
  end

  def new
    @travel_plan = current_user.travel_plans.new

    # prepopulate location/adventure if provided in params
    @travel_plan.locations << Location.find_by(id: params[:location_id]) if params[:location_id].present?
    @travel_plan.adventures << Adventure.find_by(id: params[:adventure_id]) if params[:adventure_id].present?
  end

  def create
    @travel_plan = current_user.travel_plans.build(travel_plan_params)
    if @travel_plan.save
      redirect_to @travel_plan, notice: 'Travel plan was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @travel_plan = TravelPlan.includes(:locations, :adventures).find_by(id: params[:id])
    return redirect_to travel_plans_path, alert: "Travel Plan not found." unless @travel_plan
  end

  private

  def travel_plan_params
    params.require(:travel_plan).permit(
      :title,
      :content,
      :status,
      location_ids: [],
      adventure_ids: []
    )
  end
end
