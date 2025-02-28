# app/controllers/admin/skills_controller.rb
class Admin::SkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_skill, only: [:edit, :update, :destroy, :associations,
                                   :update_adventure_associations, :update_location_associations]

  def index
    @skills = Skill.all.order(:name)
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      redirect_to admin_skills_path, notice: 'Skill was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @skill.update(skill_params)
      redirect_to admin_skills_path, notice: 'Skill was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @skill.destroy
    redirect_to admin_skills_path, notice: 'Skill was successfully deleted.'
  end

  # manage associations between skills and adventures/locations
  def associations
  end

  def update_adventure_associations
    # remove existing associations
    @skill.adventure_skills.destroy_all

    # create new associations based on selected adventure IDs
    if params[:adventure_ids].present?
      params[:adventure_ids].each do |adventure_id|
        is_required = params[:required_adventure_ids].present? &&
                      params[:required_adventure_ids].include?(adventure_id)

        @skill.adventure_skills.create(
          adventure_id: adventure_id,
          is_required: is_required
        )
      end
    end

    redirect_to associations_admin_skill_path(@skill), notice: 'Adventure associations updated successfully.'
  end

  def update_location_associations
    # remove existing associations
    @skill.location_skills.destroy_all

    # create new associations based on selected location IDs
    if params[:location_ids].present?
      params[:location_ids].each do |location_id|
        is_required = params[:required_location_ids].present? &&
                      params[:required_location_ids].include?(location_id)

        @skill.location_skills.create(
          location_id: location_id,
          is_required: is_required
        )
      end
    end

    redirect_to associations_admin_skill_path(@skill), notice: 'Location associations updated successfully.'
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(
      :name,
      :details,
      :difficulty,
      :category,
      :instructions,
      :resources,
      :video_url,
      :safety_critical
    )
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You don't have permission to access this area."
    end
  end
end
