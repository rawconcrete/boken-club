# db/seeds/locations_adventures.rb
def create_locations_adventures
  puts "Creating locations-adventures connections..."

  [
    {
      location: 'Mount Fuji Fujiyoshida 5th Station',
      adventures: ['Hiking', 'Camping', 'Star Gazing', 'Trail Running', 'Snowshoeing', 'Skiing & Snowboarding']
    },
    {
      location: 'Mount Takao',
      adventures: ['Hiking', 'Trail Running', 'Wildlife Watching', 'Cycling', 'Paragliding']
    },
    {
      location: 'Ogawayama',
      adventures: ['Rock Climbing', 'Camping', 'Hiking', 'Star Gazing', 'Trail Running']
    },
    {
      location: 'Mitake Valley',
      adventures: ['Rock Climbing', 'Hiking', 'Trail Running', 'Fishing', 'Cycling']
    },
    {
      location: 'Nagatoro',
      adventures: ['Rock Climbing', 'Hiking', 'Camping', 'Rafting', 'Fishing']
    },
    {
      location: 'Lake Kawaguchiko',
      adventures: ['Camping', 'Hiking', 'Fishing', 'Kayaking', 'Star Gazing', 'Cycling']
    },
    {
      location: 'Shiretoko National Park',
      adventures: ['Hiking', 'Wildlife Watching', 'Camping', 'Fishing', 'Kayaking', 'Snowshoeing']
    },
    {
      location: 'Shirakami-Sanchi',
      adventures: ['Trekking', 'Hiking', 'Wildlife Watching', 'Trail Running', 'Camping']
    },
    {
      location: 'Zao Mountain Range',
      adventures: ['Hiking', 'Skiing & Snowboarding', 'Snowshoeing', 'Star Gazing', 'Paragliding']
    },
    {
      location: 'Mount Chokai',
      adventures: ['Hiking', 'Trekking', 'Trail Running', 'Paragliding', 'Star Gazing']
    },
    {
      location: 'Oze National Park',
      adventures: ['Trekking', 'Camping', 'Wildlife Watching', 'Fishing', 'Trail Running']
    },
    {
      location: 'Nikko National Park',
      adventures: ['Hiking', 'Trekking', 'Wildlife Watching', 'Camping', 'Fishing', 'Cycling']
    },
    {
      location: 'Kumano Kodo',
      adventures: ['Trekking', 'Hiking', 'Trail Running', 'Wildlife Watching', 'Camping']
    },
    {
      location: 'Tateyama-Kurobe Alpine Route',
      adventures: ['Hiking', 'Skiing & Snowboarding', 'Snowshoeing', 'Star Gazing', 'Paragliding']
    },
    {
      location: 'Mount Hakusan',
      adventures: ['Hiking', 'Trekking', 'Wildlife Watching', 'Trail Running', 'Star Gazing']
    },
    {
      location: 'Kamikochi',
      adventures: ['Trekking', 'Camping', 'Wildlife Watching', 'Fishing', 'Star Gazing', 'Trail Running']
    }
  ].each do |mapping|
    location = Location.find_by(name: mapping[:location])
    if location
      mapping[:adventures].each do |adventure_name|
        adventure = Adventure.find_by(name: adventure_name)
        if adventure
          LocationsAdventure.create!(
            location: location,
            adventure: adventure
          )
        end
      end
    end
  end

  puts "Created #{LocationsAdventure.count} location-adventure connections"
end
