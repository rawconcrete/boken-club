# app/helpers/locations_helper.rb
module LocationsHelper
  def location_description(location)
    # Predefined descriptions for specific locations
    descriptions = {
      "Mount Fuji Fujiyoshida 5th Station" => "Japan's iconic volcano with challenging trails, sacred religious sites, and breathtaking sunrise views.",
      "Ogawayama" => "World-class granite climbing destination with multi-pitch routes and stunning alpine scenery.",
      "Mount Takao" => "Accessible day-hike with ancient temples, diverse trails, and panoramic Tokyo views.",
      "Mitake Valley" => "Riverside bouldering paradise with shady spots and natural pools for summer relaxation.",
      "Nagatoro" => "Rugged river gorges, autumn foliage, and thrilling whitewater rafting experiences.",
      "Lake Kawaguchiko" => "Serene Fuji views, lush forests, and peaceful lakeside trails for all seasons.",
      "Shiretoko National Park" => "Pristine wilderness with bear habitats, dramatic coastlines, and untouched forests.",
      "Shirakami-Sanchi" => "UNESCO beech forest with ancient trees, diverse wildlife, and remote hiking opportunities.",
      "Hachimantai" => "Vast highlands, steaming onsens, and untouched alpine beauty in northern Japan.",
      "Zao Mountain Range" => "Famous for winter 'snow monsters', volcanic crater lakes, and vibrant autumn colors.",
      "Mount Chokai" => "Sacred mountain straddling prefectures with challenging climbs and coastal panoramas.",
      "Mount Gassan" => "Spiritual mountain with ancient pilgrimage routes and late-season snow activities.",
      "Oze National Park" => "Japan's largest highland marsh with wooden boardwalks, wildflowers, and mountain views.",
      "Mount Tsukuba" => "Twin-peaked mountain with accessible trails, cable cars, and expansive Kanto Plain vistas.",
      "Nikko National Park" => "Historic shrines, ornate temples, vibrant autumn foliage, and dramatic waterfalls.",
      "Mount Tanigawa" => "Challenging rock face with a reputation as one of Japan's most dangerous climbing destinations.",
      "Himeji Castle" => "Spectacular White Heron castle with intact feudal architecture and cherry blossom gardens.",
      "Mt. Seppiko" => "Rugged climbing near Himeji with technical routes and rewarding summit views of Hyogo prefecture."
    }

    # Return the predefined description or generate a generic one
    descriptions[location.name] || generate_generic_description(location)
  end

  private

  def generate_generic_description(location)
    # Generate a description based on location attributes
    parts = []

    # Add prefecture context
    case location.prefecture&.downcase
    when "hokkaido"
      parts << "Northern wilderness destination"
    when "okinawa"
      parts << "Tropical island paradise"
    when "tokyo"
      parts << "Urban-accessible adventure spot"
    when "yamanashi"
      parts << "Mount Fuji region destination"
    when "kyoto"
      parts << "Historic cultural landscape"
    else
      parts << "Scenic Japanese destination"
    end

    # Add feature based on name
    if location.name.downcase.include?("mount") || location.name.downcase.include?("mt.")
      parts << "with challenging mountain trails"
    elsif location.name.downcase.include?("lake") || location.name.downcase.include?("river")
      parts << "with beautiful water features"
    elsif location.name.downcase.include?("park")
      parts << "with diverse natural environments"
    elsif location.name.downcase.include?("castle") || location.name.downcase.include?("shrine")
      parts << "with important cultural heritage"
    else
      parts << "with unique outdoor experiences"
    end

    # Add activities based on associated adventures
    adventure_types = location.adventures.pluck(:name).map(&:downcase)

    if adventure_types.any? { |a| a.include?("climb") || a.include?("boulder") }
      parts << "for climbing enthusiasts"
    elsif adventure_types.any? { |a| a.include?("hik") || a.include?("trek") }
      parts << "for hiking adventures"
    elsif adventure_types.any? { |a| a.include?("camp") }
      parts << "for overnight wilderness experiences"
    elsif adventure_types.any? { |a| a.include?("kayak") || a.include?("raft") }
      parts << "for water sport adventures"
    end

    parts.join(" ")
  end
end
