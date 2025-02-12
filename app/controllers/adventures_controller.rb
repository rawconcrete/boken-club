# app/controllers/adventures_controller.rb
class AdventuresController < ApplicationController
  def index
    @adventures = if params[:query].present?
                    Adventure.where("name ILIKE ?", "%#{params[:query]}%")
                  else
                    Adventure.all
                  end

    respond_to do |format|
      format.html
      format.json { render json: @adventures }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("adventures-list", partial: "adventures/list", locals: { adventures: @adventures }) }
    end
  end
end
