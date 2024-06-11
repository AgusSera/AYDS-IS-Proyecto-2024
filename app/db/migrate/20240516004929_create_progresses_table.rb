# OK!

class CreateProgressesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :progresses do |t|
      t.integer :last_completed_lesson, null: false, default: 0
      t.integer :current_lesson, null: false, default: 1
      t.float :numberOfCorrectAnswers, null: false, default: 0
      t.float :numberOfIncorrectAnswers, null: false, default: 0
      t.integer :numberOfAchivements, null: false, default: 0
      t.string :progressLevel, null: false, default: "Beginner"
      t.text    "correct_answered_questions", default: '[]'

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

