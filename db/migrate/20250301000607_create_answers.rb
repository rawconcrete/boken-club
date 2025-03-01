class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.text :content, null: false
      t.boolean :is_correct, default: false
      t.timestamps
    end
  end
end
