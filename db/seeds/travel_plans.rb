# db/seeds/travel_plans.rb
def create_travel_plans
  puts "Creating travel plans..."

  user1 = User.first
  user2 = User.second

  return unless user1 && user2

  plans = TravelPlan.create!([
    {
      user: user1,
      title: 'Weekend at Ogawayama',
      content: 'Multi-pitch climbing trip',
      status: 'pending',
      start_date: 1.week.from_now,
      end_date: 9.days.from_now
    },
    {
      user: user2,
      title: 'Mount Takao Day Hike',
      content: 'Day trip hiking various trails',
      status: 'pending',
      start_date: 2.weeks.from_now,
      end_date: 2.weeks.from_now
    }
  ])

  # Associate locations and adventures with travel plans
  plans.each_with_index do |plan, index|
    if index.zero?
      plan.locations << Location.find_by(name: 'Ogawayama')
      plan.adventures << Adventure.find_by(name: 'Rock Climbing')
    else
      plan.locations << Location.find_by(name: 'Mount Takao')
      plan.adventures << Adventure.find_by(name: 'Hiking')
    end

    # Add some equipment to each travel plan
    equipment_list = if index.zero?
      Equipment.where(name: ['Climbing Harness', 'Climbing Shoes', 'Rope (60m)'])
    else
      Equipment.where(name: ['Hiking Boots', 'Backpack (30-40L)', 'Water Filter'])
    end

    equipment_list.each do |equipment|
      TravelPlanEquipment.create!(
        travel_plan: plan,
        equipment: equipment,
        checked: false
      )
    end
  end

  puts "Created #{TravelPlan.count} travel plans"
  puts "Added equipment to travel plans"
end
