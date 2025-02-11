class RemoveLocationIdFromAdventures < ActiveRecord::Migration[7.1]
  def change
    remove_column :adventures, :location_id, :integer
  end
end
