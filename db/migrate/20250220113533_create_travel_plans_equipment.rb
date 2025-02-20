class CreateTravelPlansEquipment < ActiveRecord::Migration[7.1]
  def change
    create_table :travel_plans_equipments do |t|
      t.references :travel_plan, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
