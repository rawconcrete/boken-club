# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @equipment_by_category = Equipment.all.group_by(&:category)
    @user_equipment_ids = current_user.equipment.pluck(:id)
  end

  def edit
    @equipment_by_category = Equipment.all.group_by(&:category)
    @user_equipment_ids = current_user.equipment.pluck(:id)
  end

  def update
    # Handle equipment updates
    if profile_params[:equipment_ids].present?
      # Clear existing equipment associations
      current_user.user_equipments.destroy_all

      # Create new equipment associations
      profile_params[:equipment_ids].each do |equipment_id|
        current_user.user_equipments.create(equipment_id: equipment_id)
      end
    elsif params[:profile].present? && !profile_params[:equipment_ids].present?
      # If profile is submitted but no equipment IDs, clear all equipment
      current_user.user_equipments.destroy_all
    end

    # Handle user details update if provided
    user_updated = true
    if params[:user].present?
      user_updated = @user.update(user_params)
    end

    if user_updated
      redirect_to profile_path, notice: 'Profile updated successfully'
    else
      @equipment_by_category = Equipment.all.group_by(&:category)
      @user_equipment_ids = current_user.equipment.pluck(:id)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.fetch(:profile, {}).permit(equipment_ids: [])
  end

  def user_params
    params.require(:user).permit(:name) if params[:user].present?
  end
end
