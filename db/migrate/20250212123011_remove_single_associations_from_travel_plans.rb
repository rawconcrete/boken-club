class RemoveSingleAssociationsFromTravelPlans < ActiveRecord::Migration[7.1]
  def change
    remove_reference :travel_plans, :adventure, foreign_key: true if column_exists?(:travel_plans, :adventure_id)
    remove_reference :travel_plans, :location, foreign_key: true if column_exists?(:travel_plans, :location_id)
    if column_exists?(:travel_plans, :location_id)
      change_column_null :travel_plans, :location_id, true
    end
  end
end
