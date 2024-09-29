# OK!

class CreateProgressesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :progresses do |t|
      t.integer :last_completed_lesson, null: false, default: 0
      t.integer :current_lesson, null: false, default: 1
      t.string :progressLevel, null: false, default: "Beginner"
      t.text    "correct_answered_questions", default: '[]'
      t.integer :points, null: false, default: 0
      t.integer :streak, null: false, default: 0

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

