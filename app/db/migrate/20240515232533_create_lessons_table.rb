# frozen_string_literal: true

# Migration to create the lessons table. This table stores lesson information,
# including the lesson's name and content, along with timestamps for tracking
# when each lesson was created or last updated.
# Fields:
# - name: The name/title of the lesson
# - content: The main content of the lesson
# - created_at: Timestamp indicating when the lesson was created
# - updated_at: Timestamp indicating the last update to the lesson
class CreateLessonsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :content

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
