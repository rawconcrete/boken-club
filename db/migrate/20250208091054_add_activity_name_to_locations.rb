class AddActivityNameToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :activity_name, :string
  end
end
