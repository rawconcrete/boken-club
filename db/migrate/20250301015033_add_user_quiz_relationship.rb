class AddUserQuizRelationship < ActiveRecord::Migration[7.1]
  def change
    # If we create all the tables for quizzes, you don't need this
    # This is just added as a safety in case some relationships are missing

    # Make sure quiz_attempts table has user_id reference
    unless column_exists?(:quiz_attempts, :user_id)
      add_reference :quiz_attempts, :user, null: false, foreign_key: true
    end

    # Make sure quiz_attempts table has quiz_id reference
    unless column_exists?(:quiz_attempts, :quiz_id)
      add_reference :quiz_attempts, :quiz, null: false, foreign_key: true
    end
  end
end
