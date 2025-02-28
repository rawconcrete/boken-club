class CreateTravelPlanSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :travel_plan_skills do |t|
      t.references :travel_plan, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.boolean :is_mastered, default: false
      t.timestamps
    end

    # add index to prevent duplicate associations
    add_index :travel_plan_skills, [:travel_plan_id, :skill_id], unique: true
  end
end
