# app/controllers/admin/locations_controller.rb
class Admin::LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_location, only: [:edit, :update, :destroy]

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to location_path(@location), notice: "Location created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @location.update(location_params)
      redirect_to locations_path, notice: "Location updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_path, notice: "Location deleted successfully"
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :city, :prefecture, :details, :tips, :warnings)
  end

  def authorize_admin
    redirect_to root_path, alert: "Access denied" unless current_user.admin?
  end
end
