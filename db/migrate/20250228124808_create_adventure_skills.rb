class CreateAdventureSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :adventure_skills do |t|
      t.references :adventure, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.boolean :is_required, default: false
      t.timestamps
    end

    # add index to prevent duplicate associations
    add_index :adventure_skills, [:adventure_id, :skill_id], unique: true
  end
end
