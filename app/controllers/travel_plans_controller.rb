# app/controllers/travel_plans_controller.rb
class TravelPlansController < ApplicationController
  before_action :authenticate_user!

  def index
    @travel_plans = current_user.travel_plans.includes(:locations, :adventures)
  end

  def new
    @travel_plan = current_user.travel_plans.new
    setup_equipment_list
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

    title_parts << Time.current.strftime("%Y-%m-%d")
    @travel_plan.title = title_parts.compact.join(" - ")

    # debug lines
    puts "Location IDs: #{@travel_plan.location_ids}"
    puts "Adventure IDs: #{@travel_plan.adventure_ids}"
    puts "Equipment List Count: #{@equipment_list&.count}"
    puts "Equipment List: #{@equipment_list.inspect}"
  end

  def create
    @travel_plan = current_user.travel_plans.build(travel_plan_params)
    if @travel_plan.save
      create_equipment_selections
      redirect_to @travel_plan, notice: 'Travel plan was successfully created.'
    else
      setup_equipment_list
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
    setup_equipment_list
  end

  def update
    @travel_plan = current_user.travel_plans.find_by(id: params[:id])
    return redirect_to travel_plans_path, alert: "Travel Plan not found" unless @travel_plan

    if @travel_plan.update(travel_plan_params)
      update_equipment_selections
      redirect_to @travel_plan, notice: 'Travel plan updated successfully.'
    else
      setup_equipment_list
      render :edit, status: :unprocessable_entity
    end
  end

  def get_recommended_equipment
    location_ids = params[:location_ids].to_s.split(',').reject(&:blank?)
    adventure_ids = params[:adventure_ids].to_s.split(',').reject(&:blank?)
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil

    @equipment = Equipment.recommended_for(
      location_ids: location_ids,
      adventure_ids: adventure_ids,
      date: start_date
    )

    result = @equipment.select(:id, :name, :description, :category)
    Rails.logger.debug "Recommended equipment: #{result.to_json}"
    render json: result
  end

  private

  def setup_equipment_list
    location_ids = params[:location_id].present? ? [params[:location_id]] : @travel_plan.location_ids
    adventure_ids = params[:adventure_id].present? ? [params[:adventure_id]] : @travel_plan.adventure_ids

    # Handle empty arrays
    location_ids = [0] if location_ids.empty?
    adventure_ids = [0] if adventure_ids.empty?

    @equipment_list = Equipment.distinct
      .left_joins(:location_equipments, :adventure_equipments)
      .where('location_equipments.location_id IN (?) OR adventure_equipments.adventure_id IN (?)',
             location_ids, adventure_ids)

    # If no specific locations/adventures, show all equipment
    @equipment_list = Equipment.all if @equipment_list.empty?
  end

  def create_equipment_selections
    return unless params[:equipment_ids]

    params[:equipment_ids].each do |equipment_id|
      @travel_plan.travel_plan_equipments.create(
        equipment_id: equipment_id,
        checked: true
      )
    end
  end

  def update_equipment_selections
    return unless params[:equipment_ids]

    # remove existing selections that aren't in  new list
    @travel_plan.travel_plan_equipments.where.not(equipment_id: params[:equipment_ids]).destroy_all

    # add new selections
    params[:equipment_ids].each do |equipment_id|
      @travel_plan.travel_plan_equipments.find_or_create_by!(
        equipment_id: equipment_id
      ) do |tpe|
        tpe.checked = true
      end
    end
  end

  def travel_plan_params
    params.require(:travel_plan).permit(
      :title,
      :content,
      :status,
      :start_date,
      :end_date,
      location_ids: [],
      adventure_ids: [],
      equipment_ids: []
    )
  end


end
