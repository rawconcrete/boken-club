class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.references :skill, null: false, foreign_key: true
      t.references :adventure, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true
      t.string :category
      t.string :difficulty

      t.timestamps
    end
  end
end
