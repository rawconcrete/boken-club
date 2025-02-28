class UpdateSkillsTable < ActiveRecord::Migration[7.1]
  def change
    change_table :skills do |t|
      t.string :difficulty, default: 'beginner' # beginner, intermediate, advanced
      t.string :category
      t.text :instructions
      t.text :resources # URLs or book references for learning more
      t.string :video_url # tutorial video URL
      t.boolean :safety_critical, default: false
    end
  end
end
