class CreateAdventureSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :adventure_skills do |t|
      t.references :adventure, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
