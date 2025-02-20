class EquipmentController < ApplicationController
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @equipment = if params[:query].present?
      Equipment.where("name ILIKE ? OR description ILIKE ?",
        "%#{params[:query]}%",
        "%#{params[:query]}%")
    else
      Equipment.all
    end

    respond_to do |format|
      format.html
      format.json { render json: @equipment }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @equipment.to_json(include: [:locations, :adventures]) }
    end
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.save
      redirect_to @equipment, notice: 'Equipment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @equipment.update(equipment_params)
      redirect_to @equipment, notice: 'Equipment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @equipment.destroy
    redirect_to equipment_index_path, notice: 'Equipment was successfully deleted.'
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  def equipment_params
    params.require(:equipment).permit(:name, :description, :category, :affiliate_link)
  end
end
