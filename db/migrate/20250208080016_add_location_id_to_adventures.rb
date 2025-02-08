class AddLocationIdToAdventures < ActiveRecord::Migration[7.1]
  def change
    add_column :adventures, :location_id, :integer
    add_index :adventures, :location_id
  end
end
