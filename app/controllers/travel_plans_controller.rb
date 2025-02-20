# app/controllers/travel_plans_controller.rb
class TravelPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_travel_plan, except: [:index, :new, :create]

  def index
    @travel_plans = current_user.travel_plans.includes(:locations, :adventures)
  end

def new
  @travel_plan = current_user.travel_plans.new
  title_parts = []

  if params[:location_id].present?
    location = Location.find_by(id: params[:location_id])
    @travel_plan.locations << location if location
    title_parts << location&.name
  end

  if params[:adventure_id].present?
    adventure = Adventure.find_by(id: params[:adventure_id])
    @travel_plan.adventures << adventure if adventure
    title_parts << adventure&.name
  end

  # add handling for equipment
  if params[:equipment_id].present?
    @equipment = Equipment.find_by(id: params[:equipment_id])
    @travel_plan.equipment << @equipment if @equipment
  end

  title_parts << Time.current.strftime("%Y-%m-%d")
  @travel_plan.title = title_parts.compact.join(" - ")
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
    @travel_plan = current_user.travel_plans.includes(:locations, :adventures).find_by(id: params[:id])
    return redirect_to travel_plans_path, alert: "Travel Plan not found" unless @travel_plan

    respond_to do |format|
      format.html
      format.json { render json: @travel_plan.as_json(include: [:locations, :adventures]) }
    end
  end

  def destroy
    @travel_plan = current_user.travel_plans.find_by(id: params[:id])
    return redirect_to travel_plans_path, alert: "Travel Plan not found" unless @travel_plan

    @travel_plan.destroy
    redirect_to travel_plans_path, notice: "Travel plan deleted successfully"
  end

  def edit
    @travel_plan = current_user.travel_plans.find_by(id: params[:id])
    return redirect_to travel_plans_path, alert: "Travel Plan not found" unless @travel_plan
  end


  def update
    @travel_plan = current_user.travel_plans.find_by(id: params[:id])
    return redirect_to travel_plans_path, alert: "Travel Plan not found" unless @travel_plan

    if @travel_plan.update(travel_plan_params)
      redirect_to @travel_plan, notice: 'Travel plan updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def add_item
    item_type = params[:item_type]
    item_id = params[:item_id]

    case item_type
    when 'equipment'
      @travel_plan.equipment_ids = (@travel_plan.equipment_ids + [item_id]).uniq
    when 'adventure'
      @travel_plan.adventure_ids = (@travel_plan.adventure_ids + [item_id]).uniq
    when 'location'
      @travel_plan.location_ids = (@travel_plan.location_ids + [item_id]).uniq
    end

    if @travel_plan.save
      render json: { success: true }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
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

  def set_travel_plan
    @travel_plan = current_user.travel_plans.find(params[:id])
  end
end
