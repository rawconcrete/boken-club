class CreateTravelPlanSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :travel_plan_skills do |t|

      t.timestamps
    end
  end
end
