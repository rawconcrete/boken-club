class AddDateToTravelPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :travel_plans, :start_date, :date
    add_column :travel_plans, :end_date, :date
  end
end
