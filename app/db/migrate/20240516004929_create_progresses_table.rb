# OK!

class CreateProgressesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :progresses do |t|
      t.integer :current_lesson, null: false, default: 1
      t.integer :numberOfCorrectAnswers
      t.integer :numberOfAchivements
      t.string :progressLevel

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
