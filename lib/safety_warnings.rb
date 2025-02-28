# app/lib/safety_warnings.rb
module SafetyWarnings
  class Generator
    def self.for_travel_plan(travel_plan)
      warnings = []

      # Add location-based warnings
      travel_plan.locations.each do |location|
        warnings.concat(location_warnings(location))
      end

      # Add adventure-based warnings
      travel_plan.adventures.each do |adventure|
        warnings.concat(adventure_warnings(adventure))
      end

      # Add date/season-based warnings
      if travel_plan.start_date.present?
        warnings.concat(seasonal_warnings(travel_plan.start_date))
      end

      # Add simulated weather warnings
      warnings.concat(simulated_weather_warnings(travel_plan))

      # Remove duplicates and return
      warnings.uniq
    end

    private

    def self.location_warnings(location)
      warnings = []

      # Altitude warnings
      if location.name.downcase.include?('fuji') || location.name.downcase.include?('mountain') || location.name.downcase.match(/mt\.?\s/)
        warnings << "Altitude sickness possible above 2,500m. Acclimatize properly and consider descending if symptoms occur."
      end

      # Prefecture-specific warnings
      case location.prefecture&.downcase
      when 'hokkaido'
        warnings << "Bear activity reported in this region. Carry bear bells and keep food properly stored."
        warnings << "Extreme winter temperatures possible. Pack appropriate cold weather gear."
      when 'okinawa'
        warnings << "Strong sea currents possible. Check local advisories before water activities."
        warnings << "High UV index year-round. Use reef-safe sunscreen and protective clothing."
      end

      # Terrain-based warnings
      if location.name.downcase.include?('valley') || location.name.downcase.include?('gorge')
        warnings << "Flash flooding possible in gorges and valleys. Check weather forecasts thoroughly."
      end

      if location.warnings.present?
        warnings << location.warnings
      end

      warnings
    end

    def self.adventure_warnings(adventure)
      warnings = []

      case adventure.name.downcase
      when /climbing/, /bouldering/
        warnings << "Proper climbing equipment and technique essential. Consider a local guide if unfamiliar with the routes."
      when /hiking/, /trekking/
        warnings << "Carry sufficient water and navigation tools. Inform someone of your route and expected return time."
      when /kayaking/, /rafting/
        warnings << "Personal flotation device required. Check water conditions before departure."
      when /skiing/, /snowboarding/
        warnings << "Avalanche risk assessment recommended. Carry appropriate safety equipment."
      end

      if adventure.warnings.present?
        warnings << adventure.warnings
      end

      warnings
    end

    def self.seasonal_warnings(date)
      warnings = []
      month = date.month

      case month
      when 12, 1, 2 # Winter
        warnings << "Winter conditions: Shorter daylight hours, prepare headlamps and extra layers."
        warnings << "Hypothermia risk increased. Pack extra warm clothing even for day trips."
      when 6, 7, 8 # Summer
        warnings << "Summer heat: Increased risk of heat exhaustion and dehydration. Carry extra water."
        warnings << "Higher UV exposure. Use sunscreen, protective clothing, and sunglasses."
      when 4, 5 # Spring
        warnings << "Spring thaw may cause unstable trail conditions and swollen water crossings."
      when 9, 10, 11 # Autumn
        warnings << "Autumn temperature fluctuations can be significant. Pack layers."
        warnings << "Earlier sunset times may affect hiking schedules. Plan accordingly."
      end

      # Rainy season (tsuyu) warnings
      if month == 6 || month == 7
        warnings << "Rainy season (tsuyu) may cause slippery trails and reduced visibility."
      end

      warnings
    end

    def self.simulated_weather_warnings(travel_plan)
      warnings = []
      return warnings unless travel_plan.start_date.present?

      # Simulate API by generating random weather warnings based on season
      month = travel_plan.start_date.month

      # Use the travel plan ID as a seed to ensure consistent "random" warnings
      seed = travel_plan.id || rand(1000)
      r = Random.new(seed)

      # Winter warnings (Dec-Feb)
      if [12, 1, 2].include?(month)
        if r.rand < 0.7 # 70% chance
          temp = -(5 + r.rand(15)) # -5 to -20°C
          warnings << "Weather Alert: Forecasted low of #{temp}°C. Extreme cold weather gear required."
        end

        if r.rand < 0.6 # 60% chance
          snow_cm = 10 + r.rand(50) # 10-60cm
          warnings << "Weather Alert: Heavy snowfall (#{snow_cm}cm) expected. Check avalanche conditions and road closures."
        end
      end

      # Summer warnings (Jun-Aug)
      if [6, 7, 8].include?(month)
        if r.rand < 0.6 # 60% chance
          temp = 30 + r.rand(10) # 30-40°C
          warnings << "Weather Alert: Extreme heat warning. Forecasted high of #{temp}°C. Risk of heat stroke."
        end

        if r.rand < 0.3 # 30% chance
          warnings << "Weather Alert: Thunderstorms possible in the afternoon. Seek shelter if lightning observed."
        end
      end

      # Typhoon season (Jul-Oct)
      if [7, 8, 9, 10].include?(month) && r.rand < 0.4 # 40% chance during typhoon season
        warnings << "Weather Alert: Typhoon monitoring advised. Check Japan Meteorological Agency for updates before departure."
      end

      # Rainy season (Jun-Jul)
      if [6, 7].include?(month) && r.rand < 0.7 # 70% chance during rainy season
        rainfall = 50 + r.rand(100) # 50-150mm
        warnings << "Weather Alert: Heavy rainfall (#{rainfall}mm) expected. Increased flooding and landslide risk."
      end

      warnings
    end
  end
end
