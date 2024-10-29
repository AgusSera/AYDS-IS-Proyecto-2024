# frozen_string_literal: true

# Migration to create the progresses table. This table stores data related to the user's
# progress through lessons, tracking their current lesson, completed lessons, level, points,
# and answer streaks.
#
# Fields:
# - last_completed_lesson: Stores the ID of the last completed lesson by the user (default is 0)
# - current_lesson: Indicates the ID of the current lesson the user is on (default is 1)
# - progressLevel: Indicates the user's progress level, with a default of 'Beginner'
# - correct_answered_questions: JSON-formatted array storing IDs of questions answered correctly
# - points: Tracks the user’s accumulated points (default is 0)
# - streak: Tracks the user's current answer streak for consecutive correct answers (default is 0)
# - created_at: Timestamp indicating when the progress record was created
# - updated_at: Timestamp indicating the last update to the progress record
class CreateProgressesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :progresses do |t|
      t.integer :last_completed_lesson, null: false, default: 0
      t.integer :current_lesson, null: false, default: 1
      t.string :progressLevel, null: false, default: 'Beginner'
      t.text    'correct_answered_questions', default: '[]'
      t.integer :points, null: false, default: 0
      t.integer :streak, null: false, default: 0

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
