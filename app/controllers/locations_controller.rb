class LocationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @locations = if params[:query].present?
      Location.where("name ILIKE ? OR city ILIKE ? OR prefecture ILIKE ? OR details ILIKE ? OR tips ILIKE ? OR warnings ILIKE ? OR adventure_name ILIKE ?",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%")
    else
      Location.all
    end

    # Ensure all locations have coordinates before creating markers
    @locations.each do |location|
      ensure_location_coordinates(location)
    end

    @markers = @locations.map do |location|
      {
        id: location.id,
        name: location.name,
        city: location.city,
        prefecture: location.prefecture,
        lat: location.latitude,
        lng: location.longitude
      }
    end.select { |marker| valid_coordinates?(marker[:lat], marker[:lng]) }

    respond_to do |format|
      format.html
      format.json { render json: @locations }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("locations-list", partial: "locations/list", locals: { locations: @locations }) }
    end
  end

  def show
    @location = Location.find_by(id: params[:id])

    if @location.nil?
      respond_to do |format|
        format.html { redirect_to locations_path, alert: "Location not found" }
        format.json { render json: { error: "Location not found" }, status: :not_found }
      end
      return
    end

    # Make sure the location has valid coordinates
    ensure_location_coordinates(@location)

    # Create the marker with the location's coordinates
    @markers = [
      {
        id: @location.id,
        name: @location.name,
        city: @location.city,
        prefecture: @location.prefecture,
        lat: @location.latitude,
        lng: @location.longitude
      }
    ].select { |marker| valid_coordinates?(marker[:lat], marker[:lng]) }

    respond_to do |format|
      format.html
      format.json {
        render json: {
          id: @location.id,
          name: @location.name,
          city: @location.city,
          prefecture: @location.prefecture,
          lat: @location.latitude,
          lng: @location.longitude
        }
      }
    end
  end

  private

  # Ensure location has valid coordinates
  def ensure_location_coordinates(location)
    # Skip if location already has valid coordinates
    return if valid_coordinates?(location.latitude, location.longitude)

    # Use our hardcoded coordinates for known locations
    special_locations = {
      "Mount Fuji Fujiyoshida 5th Station" => [138.7274, 35.3960],
      "Mount Takao" => [139.2438, 35.6252],
      "Lake Kawaguchiko" => [138.7550, 35.5171],
      "Shiretoko National Park" => [144.3580, 44.0772],
      "Nikko National Park" => [139.6183, 36.7407],
      "Ogawayama" => [138.4852, 36.0409],
      "Mitake Valley" => [139.1333, 35.8167],
      "Zao Mountain Range" => [140.4417, 38.1431],
      "Mount Chokai" => [140.0247, 39.0986],
      "Mount Gassan" => [139.9842, 38.5489],
      "Oze National Park" => [139.2222, 36.9042],
      "Mount Tanigawa" => [138.9300, 36.8344],
      "Nagatoro" => [139.1094, 36.0944],
      "Hachimantai" => [140.8540, 39.9583],
      "Mount Tsukuba" => [140.1066, 36.2252],
      "Himeji Castle" => [134.6939, 34.8396],
      "Mt. Seppiko" => [134.7097, 34.8652]
    }

    # Check if we have hardcoded coordinates for this location
    if special_locations.key?(location.name)
      coords = special_locations[location.name]
      location.longitude = coords[0]
      location.latitude = coords[1]

      # Save the coordinates to the database
      location.save

      Rails.logger.info("Set coordinates for #{location.name} using predefined values")

    # Try to geocode if possible for other locations
    elsif location.full_address.present?
      Rails.logger.info("Attempting to geocode #{location.name} with address: #{location.full_address}")

      # Try geocoding
      location.geocode

      # Save if geocoding was successful
      if valid_coordinates?(location.latitude, location.longitude)
        location.save
        Rails.logger.info("Successfully geocoded #{location.name}")
      else
        Rails.logger.warn("Failed to geocode #{location.name}")
      end
    else
      Rails.logger.warn("No coordinates available for #{location.name}")
    end
  end

  # Check if coordinates are valid
  def valid_coordinates?(lat, lng)
    lat.present? && lng.present? &&
    lat != 0 && lng != 0 &&
    lat.between?(-90, 90) && lng.between?(-180, 180)
  end
end
