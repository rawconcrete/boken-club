# app/controllers/equipment_controller.rb
class EquipmentController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search]

  def index
    @equipment = if params[:query].present?
      Equipment.where("name ILIKE ? OR description ILIKE ?",
      "%#{params[:query]}%",
      "%#{params[:query]}%")
    else
      Equipment.all
    end

    @equipment_by_category = @equipment.group_by(&:category)

    respond_to do |format|
      format.html
      format.json { render json: @equipment }
    end
  end

  def show
    @equipment = Equipment.find(params[:id])
    @related_skills = @equipment.skills

    respond_to do |format|
      format.html
      format.json { render json: @equipment }
    end
  end

  def search
    query = params[:q].to_s.downcase.strip
    @equipment = Equipment.where("LOWER(name) LIKE :query OR LOWER(description) LIKE :query", query: "%#{query}%")

    render json: @equipment.map { |eq| {
      id: eq.id,
      name: eq.name,
      description: eq.description,
      category: eq.category
    }}
  end
end
