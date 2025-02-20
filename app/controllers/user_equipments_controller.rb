class UserEquipmentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user_equipment = current_user.user_equipments.build(user_equipment_params)
    if @user_equipment.save
      redirect_to user_equipment_path, notice: 'Equipment added to your profile.'
    else
      redirect_to equipment_path(@user_equipment.equipment), alert: 'Unable to add equipment.'
    end
  end

  def destroy
    @user_equipment = current_user.user_equipments.find(params[:id])
    @user_equipment.destroy
    redirect_to user_equipment_path, notice: 'Equipment removed from your profile.'
  end

  private

  def user_equipment_params
    params.require(:user_equipment).permit(:equipment_id)
  end
end
