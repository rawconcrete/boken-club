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
    if profile_params[:equipment_ids].present?
      # Clear existing equipment associations
      current_user.user_equipments.destroy_all

      # Create new equipment associations
      profile_params[:equipment_ids].each do |equipment_id|
        current_user.user_equipments.create(equipment_id: equipment_id)
      end
    else
      current_user.user_equipments.destroy_all
    end

    if @user.update(user_params)
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
    params.require(:profile).permit(equipment_ids: [])
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end
end
