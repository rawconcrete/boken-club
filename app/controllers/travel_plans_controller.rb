# app/controllers/travel_plans_controller.rb
class TravelPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_travel_plan, only: [:show, :edit, :update, :destroy, :mark_equipment_purchased, :update_equipment_status]

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
    @travel_plan = current_user.travel_plans.includes(:locations, :adventures, :equipment).find_by(id: params[:id])
    return redirect_to travel_plans_path, alert: "Travel Plan not found" unless @travel_plan

    # get user's owned equipment
    @user_equipment_ids = current_user.equipment_ids

    # separate equipment into "pack" and "buy" lists
    @equipment_to_pack = @travel_plan.travel_plan_equipments.includes(:equipment).where(equipment_id: @user_equipment_ids)
    @equipment_to_buy = @travel_plan.travel_plan_equipments.includes(:equipment).where.not(equipment_id: @user_equipment_ids)

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

  # update the checked status of an equipment item in the travel plan
  def update_equipment_status
    equipment_id = params[:equipment_id]
    checked = params[:checked]

    travel_plan_equipment = @travel_plan.travel_plan_equipments.find_by(equipment_id: equipment_id)

    if travel_plan_equipment
      if travel_plan_equipment.update(checked: checked)
        respond_to do |format|
          format.html { redirect_to @travel_plan, notice: 'Equipment status updated.' }
          format.json { render json: { success: true } }
        end
      else
        respond_to do |format|
          format.html { redirect_to @travel_plan, alert: 'Failed to update equipment status.' }
          format.json { render json: { success: false, errors: travel_plan_equipment.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @travel_plan, alert: 'Equipment not found in this travel plan.' }
        format.json { render json: { success: false, error: 'Equipment not found in this travel plan' }, status: :not_found }
      end
    end
  end

  # mark equipment as purchased and add to user's equipment
  def mark_equipment_purchased
    equipment_id = params[:equipment_id]

    # find the equipment
    equipment = Equipment.find_by(id: equipment_id)

    unless equipment
      respond_to do |format|
        format.html { redirect_to @travel_plan, alert: "Equipment not found" }
        format.json { render json: { success: false, error: "Equipment not found" }, status: :not_found }
      end
      return
    end

    # add to user's equipment if not already owned
    unless current_user.owns_equipment?(equipment_id)
      user_equipment = current_user.user_equipments.create(equipment_id: equipment_id)

      unless user_equipment.persisted?
        respond_to do |format|
          format.html { redirect_to @travel_plan, alert: "Failed to add equipment to your collection" }
          format.json { render json: { success: false, errors: user_equipment.errors.full_messages }, status: :unprocessable_entity }
        end
        return
      end
    end

    respond_to do |format|
      format.html { redirect_to @travel_plan, notice: "#{equipment.name} marked as purchased and added to your equipment" }
      format.json { render json: { success: true, message: "#{equipment.name} marked as purchased" } }
    end
  end

  # equipment sorting stuff is here
  def get_recommended_equipment
    location_ids = params[:location_ids].to_s.split(',').reject(&:blank?)
    adventure_ids = params[:adventure_ids].to_s.split(',').reject(&:blank?)
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil

    # define basic equipment as default
    basic_equipment_names = ["First Aid Kit", "Water Bottle", "Backpack (30-40L)"]

    # always load equipment
    if location_ids.present? || adventure_ids.present? || start_date.present?
      # fetch equipment for locations
      location_equipment = location_ids.present? ?
        Equipment.for_location(location_ids).pluck(:id) : []

      # fetch equipment for adventures
      adventure_equipment = adventure_ids.present? ?
        Equipment.for_adventure(adventure_ids).pluck(:id) : []

      # fetch seasonal equipment if date is provided
      seasonal_equipment = start_date.present? ?
        Equipment.for_season(start_date).pluck(:id) : []

      # combine all equipment IDs
      all_equipment_ids = (location_equipment + adventure_equipment + seasonal_equipment).uniq

      # get equipment with sources
      if all_equipment_ids.any?
        equipment_items = Equipment.where(id: all_equipment_ids)

        result = equipment_items.as_json(only: [:id, :name, :description, :category]).map do |item|
          item["sources"] = []
          item["user_owned"] = current_user.owns_equipment?(item["id"])
          item["is_essential"] = basic_equipment_names.include?(item["name"])

          # first check if it's a basic item
          if basic_equipment_names.include?(item["name"])
            item["sources"] << "Basic"
          else
            # otherwise, add source labels
            if location_ids.present? && location_equipment.include?(item["id"])
              item["sources"] << "Location"
            end

            if adventure_ids.present? && adventure_equipment.include?(item["id"])
              item["sources"] << "Adventure"
            end

            if start_date.present? && seasonal_equipment.include?(item["id"])
              item["sources"] << "Season"
            end
          end

          item
        end

        @equipment = result
      else
        # fallback to basic equipment
        @equipment = Equipment.where(name: basic_equipment_names)
          .as_json(only: [:id, :name, :description, :category])
          .map do |item|
            item.merge({
              "sources" => ["Basic"],
              "user_owned" => current_user.owns_equipment?(item["id"]),
              "is_essential" => true
            })
          end
      end
    else
      # return only basic equipment when no filters are applied
      @equipment = Equipment.where(name: basic_equipment_names)
        .as_json(only: [:id, :name, :description, :category])
        .map do |item|
          item.merge({
            "sources" => ["Basic"],
            "user_owned" => current_user.owns_equipment?(item["id"]),
            "is_essential" => true
          })
        end
    end

    render json: @equipment
  end

  private

  def set_travel_plan
    @travel_plan = current_user.travel_plans.find_by(id: params[:id])
    redirect_to travel_plans_path, alert: "Travel Plan not found" unless @travel_plan
  end

  def setup_equipment_list
    location_ids = params[:location_id].present? ? [params[:location_id]] : @travel_plan.location_ids
    adventure_ids = params[:adventure_id].present? ? [params[:adventure_id]] : @travel_plan.adventure_ids

    # handle empty arrays
    location_ids = [0] if location_ids.empty?
    adventure_ids = [0] if adventure_ids.empty?

    @equipment_list = Equipment.distinct
      .left_joins(:location_equipments, :adventure_equipments)
      .where('location_equipments.location_id IN (?) OR adventure_equipments.adventure_id IN (?)',
             location_ids, adventure_ids)

    # if no specific locations/adventures, show the basic equipment
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
