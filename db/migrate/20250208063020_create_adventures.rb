class CreateAdventures < ActiveRecord::Migration[7.1]
  def change
    create_table :adventures do |t|
      t.string :name
      t.string :details
      t.string :tips
      t.string :warnings
      t.string :skills

      t.timestamps
    end
  end
end
