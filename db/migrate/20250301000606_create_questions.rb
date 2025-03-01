class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.text :content, null: false
      t.string :difficulty, default: 'medium'
      t.string :explanation
      t.timestamps
    end
  end
end
