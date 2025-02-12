class RenameActivityNameToAdventureName < ActiveRecord::Migration[7.1]
  def change
    rename_column :locations, :activity_name, :adventure_name
  end
end
