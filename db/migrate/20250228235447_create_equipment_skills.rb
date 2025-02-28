class CreateEquipmentSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :equipment_skills do |t|

      t.timestamps
    end
  end
end
