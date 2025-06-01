class CreateLocationSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :location_skills do |t|
      t.references :location, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.boolean :is_required, default: false
      t.timestamps
    end

    # add index to prevent duplicate associations
    add_index :location_skills, [:location_id, :skill_id], unique: true
  end
end
