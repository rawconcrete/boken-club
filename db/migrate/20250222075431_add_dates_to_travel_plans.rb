# db/migrate/20250222075431_add_dates_to_travel_plans.rb
class AddDatesToTravelPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :travel_plans, :start_date, :datetime
    add_column :travel_plans, :end_date, :datetime
  end
end
