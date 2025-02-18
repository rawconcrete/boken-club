class CreateAdventureEquipments < ActiveRecord::Migration[7.1]
  def change
    create_table :adventure_equipments do |t|
      t.references :adventure, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
