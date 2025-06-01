# app/controllers/user_equipments_controller.rb
class UserEquipmentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user_equipment = current_user.user_equipments.new(user_equipment_params)

    if @user_equipment.save
      respond_to do |format|
        format.html { redirect_back(fallback_location: profile_path, notice: "Equipment added to your collection.") }
        format.json { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: profile_path, alert: "Failed to add equipment.") }
        format.json { render json: { success: false, errors: @user_equipment.errors.full_messages } }
      end
    end
  end

  def update
    @user_equipment = current_user.user_equipments.find_by(id: params[:id])

    if @user_equipment&.update(user_equipment_params)
      respond_to do |format|
        format.html { redirect_back(fallback_location: profile_path, notice: "Equipment updated.") }
        format.json { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: profile_path, alert: "Failed to update equipment.") }
        format.json { render json: { success: false, errors: @user_equipment&.errors&.full_messages || ["Equipment not found"] } }
      end
    end
  end

  def destroy
    @user_equipment = current_user.user_equipments.find_by(id: params[:id])

    if @user_equipment&.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: profile_path, notice: "Equipment removed from your collection.") }
        format.json { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: profile_path, alert: "Failed to remove equipment.") }
        format.json { render json: { success: false, errors: ["Equipment not found"] } }
      end
    end
  end

  private

  def user_equipment_params
    params.require(:user_equipment).permit(:equipment_id, :memo)
  end
end
