class CreateAdventureTravelPlanDisclaimers < ActiveRecord::Migration[7.1]
  def change
    create_table :adventure_travel_plan_disclaimers do |t|
      t.references :adventure, null: false, foreign_key: true
      t.references :travel_plan, null: false, foreign_key: true
      t.text :disclaimer

      t.timestamps
    end
  end
end
