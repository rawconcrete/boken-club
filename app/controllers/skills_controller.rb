# app/controllers/skills_controller.rb
class SkillsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @skills = if params[:query].present?
      Skill.search_by_name(params[:query])
    else
      Skill.all
    end

    # filter by difficulty if provided
    if params[:difficulty].present?
      @skills = @skills.where(difficulty: params[:difficulty])
    end

    # filter by category if provided
    if params[:category].present?
      @skills = @skills.where(category: params[:category])
    end

    # filter by safety_critical if provided
    if params[:safety_critical] == "true"
      @skills = @skills.where(safety_critical: true)
    end

    respond_to do |format|
      format.html
      format.json { render json: @skills }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "skills-list",
          partial: "skills/list",
          locals: { skills: @skills }
        )
      }
    end
  end

  def show
    @skill = Skill.find_by(id: params[:id])

    if @skill.nil?
      respond_to do |format|
        format.html { redirect_to skills_path, alert: "Skill not found" }
        format.json { render json: { error: "Skill not found" }, status: :not_found }
      end
      return
    end

    # get related adventures and locations for this skill
    @related_adventures = @skill.adventures
    @related_locations = @skill.locations

    respond_to do |format|
      format.html
      format.json { render json: @skill }
    end
  end
end
