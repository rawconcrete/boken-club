# db/migrate/20250222075431_add_dates_to_travel_plans.rb
class AddDatesToTravelPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :travel_plans, :start_date, :date
    add_column :travel_plans, :end_date, :date
  end
end
