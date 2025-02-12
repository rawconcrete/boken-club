# app/controllers/adventures_controller.rb
class AdventuresController < ApplicationController
  def index
    @adventures = if params[:query].present?
                    Adventure.where("name ILIKE ?", "%#{params[:query]}%")
                  else
                    Adventure.all
                  end
  end

  def show
    @adventure = Adventure.includes(:locations).find(params[:id])
  end
end
