#20250208063000_create_locations.rb
class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :details
      t.string :city
      t.string :prefecture
      t.string :tips
      t.string :warnings

      t.timestamps
    end
  end
end
