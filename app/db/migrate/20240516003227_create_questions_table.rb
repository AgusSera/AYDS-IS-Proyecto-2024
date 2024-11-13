# frozen_string_literal: true

# Migration to create the questions table. This table stores individual questions
# associated with a specific lesson, along with counters to track correct and incorrect
# answers for each question.
#
# Fields:
# - description: The text or prompt of the question
# - lesson_id: References the associated lesson, establishing a foreign key constraint
# - correct_answers_count: Integer counter to track the number of times the question was answered correctly
# - incorrect_answers_count: Integer counter to track the number of times the question was answered incorrectly
# - created_at: Timestamp indicating when the question was created
# - updated_at: Timestamp indicating the last update to the question
class CreateQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :description
      t.references :lesson, foreign_key: true
      t.integer :correct_answers_count, default: 0
      t.integer :incorrect_answers_count, default: 0

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
