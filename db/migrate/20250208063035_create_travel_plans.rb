class CreateTravelPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :travel_plans do |t|
      t.string :title
      t.string :content
      t.string :status
      t.references :adventure, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
