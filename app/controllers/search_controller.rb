class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    query = params[:q].to_s.downcase.strip

    # search locations and adventures by name, details, tips, warnings
    locations = Location.where("LOWER(name) LIKE :query OR LOWER(details) LIKE :query OR LOWER(tips) LIKE :query OR LOWER(warnings) LIKE :query", query: "%#{query}%")
                        .select(:id, :name)

    adventures = Adventure.where("LOWER(name) LIKE :query OR LOWER(details) LIKE :query OR LOWER(tips) LIKE :query OR LOWER(warnings) LIKE :query", query: "%#{query}%")
                          .select(:id, :name)

    suggestions = []
    suggestions += locations.map { |loc| { type: "location", id: loc.id, name: loc.name } }
    suggestions += adventures.map { |adv| { type: "adventure", id: adv.id, name: adv.name } }

    # always add "Search Locations for X" and "Search Adventures for X"
    suggestions.push({ type: "index_search", category: "locations", query: query, name: "Search Locations for \"#{query}\"" })
    suggestions.push({ type: "index_search", category: "adventures", query: query, name: "Search Adventures for \"#{query}\"" })

    # if no query, return all locations and adventures
    if query.blank?
      all_locations = Location.pluck(:id, :name).map { |id, name| { type: "location", id: id, name: name } }
      all_adventures = Adventure.pluck(:id, :name).map { |id, name| { type: "adventure", id: id, name: name } }
      render json: all_locations + all_adventures and return
    end

    render json: suggestions
  end
end
