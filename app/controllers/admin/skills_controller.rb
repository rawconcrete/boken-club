# app/controllers/admin/skills_controller.rb
class Admin::SkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_skill, only: [:edit, :update, :destroy]

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
