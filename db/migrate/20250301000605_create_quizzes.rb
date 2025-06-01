class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|
      t.string :title, null: false
      t.text :description
      t.references :skill, foreign_key: true
      t.references :adventure, foreign_key: true
      t.references :equipment, foreign_key: true
      t.string :category
      t.string :difficulty
      t.timestamps
    end
  end
end
