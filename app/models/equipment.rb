def self.recommended_for(location_ids: nil, adventure_ids: nil, date: nil)
  base_scope = all  # start with all equipment

  # get matching equipment
  matches = []

  # add location-specific equipment
  if location_ids.present?
    location_equipment = for_location(location_ids)
    matches << location_equipment.pluck(:id) if location_equipment.exists?
  end

  # add adventure-specific equipment
  if adventure_ids.present?
    adventure_equipment = for_adventure(adventure_ids)
    matches << adventure_equipment.pluck(:id) if adventure_equipment.exists?
  end

  # add seasonal equipment
  if date.present?
    seasonal_equipment = for_season(date)
    matches << seasonal_equipment.pluck(:id) if seasonal_equipment.exists?
  end

  # filter to matching equipment if we have matches
  if matches.any?
    # flatten all matched IDs into a single array
    matching_ids = matches.flatten.uniq
    # return only equipment with those IDs
    where(id: matching_ids)
  else
    # if no matches, return a subset of general equipment
    where(category: ["essential", "safety"]).or(where(name: ["Water Bottle", "First Aid Kit"]))
  end
end
