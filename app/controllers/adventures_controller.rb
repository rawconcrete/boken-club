# app/controllers/adventures_controller.rb
class AdventuresController < ApplicationController
  def index
    if params[:query].present?
      @adventures = Adventure.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @adventures = Adventure.all
    end
  end

  def show
    @adventure = Adventure.includes(:locations).find(params[:id])
  end
end
