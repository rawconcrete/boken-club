class SearchController < ApplicationController
  def index
    query = params[:q].downcase
    adventures = Adventure.where("name ILIKE ?", "%#{query}%").pluck(:name)
    locations = Location.where("name ILIKE ?", "%#{query}%").pluck(:name)
    render json: adventures + locations
  end
end
