class CreateTips < ActiveRecord::Migration[7.1]
  def change
    create_table :tips do |t|
      t.string :title
      t.text :content
      t.string :category

      t.timestamps
    end
  end
end
