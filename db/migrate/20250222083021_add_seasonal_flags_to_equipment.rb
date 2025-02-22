# db/migrate/20250222083021_add_seasonal_flags_to_equipment.rb
class AddSeasonalFlagsToEquipment < ActiveRecord::Migration[7.1]
  def change
    add_column :equipment, :spring_recommended, :boolean, default: false
    add_column :equipment, :summer_recommended, :boolean, default: false
    add_column :equipment, :autumn_recommended, :boolean, default: false
    add_column :equipment, :winter_recommended, :boolean, default: false
  end
end
