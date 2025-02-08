class CreateLocationsAdventures < ActiveRecord::Migration[7.1]
  def change
    create_table :locations_adventures do |t|
      t.references :adventure, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.text :additionaldetails
      t.text :warnings

      t.timestamps
    end
  end
end
