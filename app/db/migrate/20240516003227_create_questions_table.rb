# OK!

class CreateQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :description
      t.references :lesson, foreign_key: true
      t.correct_answers_count :integer, default: 0

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
