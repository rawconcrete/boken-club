class CreateTravelPlansLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :travel_plans_locations do |t|
      t.references :travel_plan, foreign_key: true, null: false
      t.references :location, foreign_key: true, null: false

      t.timestamps
    end
  end
end
