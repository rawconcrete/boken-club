class TravelPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_travel_plan, except: [:index, :new, :create]

  def new
    @travel_plan = current_user.travel_plans.new
    title_parts = []

    if params[:location_id].present?
      location = Location.find_by(id: params[:location_id])
      if location
        @travel_plan.locations << location
        title_parts << location.name
        # do not automatically add equipment here anymore
      end
    end

    if params[:adventure_id].present?
      adventure = Adventure.find_by(id: params[:adventure_id])
      if adventure
        @travel_plan.adventures << adventure
        title_parts << adventure.name
        # do not automatically add equipment here anymore
      end
    end

    title_parts << Time.current.strftime("%Y-%m-%d")
    @travel_plan.title = title_parts.compact.join(" - ")
  end

  def create
    @travel_plan = current_user.travel_plans.build(travel_plan_params)

    if @travel_plan.save
      # clear localStorage after successful save
      flash[:javascript] = "localStorage.removeItem('selectedEquipment');"
      redirect_to @travel_plan, notice: 'Travel plan was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @travel_plan.update(travel_plan_params)
      # clear localStorage after successful update
      flash[:javascript] = "localStorage.removeItem('selectedEquipment');"
      redirect_to @travel_plan, notice: 'Travel plan updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def travel_plan_params
    params.require(:travel_plan).permit(
      :title,
      :content,
      :status,
      location_ids: [],
      adventure_ids: [],
      equipment_ids: []  # make sure this is included
    )
  end

  def set_travel_plan
    @travel_plan = current_user.travel_plans.find(params[:id])
  end
end
