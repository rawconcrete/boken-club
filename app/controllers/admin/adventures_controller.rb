# app/controllers/admin/adventures_controller.rb
class Admin::AdventuresController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_adventure, only: [:edit, :update, :destroy]

  def new
    @adventure = Adventure.new
  end

  def create
    @adventure = Adventure.new(adventure_params)
    if @adventure.save
      redirect_to adventures_path(@adventures), notice: "Adventure created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @adventure.update(adventure_params)
      redirect_to adventures_path, notice: "Adventure updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @adventure.destroy
    redirect_to adventures_path, notice: "Adventure deleted successfully"
  end

  private

  def set_adventure
    @adventure = Adventure.find(params[:id])
  end

  def adventure_params
    params.require(:adventure).permit(:name, :details, :tips, :warnings, :id_location)
  end

  def authorize_admin
    redirect_to root_path, alert: "Access denied" unless current_user.admin?
  end
end
