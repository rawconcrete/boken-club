class CreateEquipmentSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :equipment_skills do |t|
      t.references :equipment, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.text :usage_tips
      t.boolean :is_required, default: false
      t.timestamps
    end

    # Add index to prevent duplicate associations
    add_index :equipment_skills, [:equipment_id, :skill_id], unique: true
  end
end
