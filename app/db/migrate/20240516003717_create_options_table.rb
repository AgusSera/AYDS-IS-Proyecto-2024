# frozen_string_literal: true

# Migration to create the options table. This table stores multiple-choice options
# for each question, allowing each option to be associated with a question and
# marked as correct or incorrect.
#
# Fields:
# - value: Boolean indicating if this option is correct (true) or incorrect (false)
# - description: The text of the option
# - question_id: References the associated question, establishing a foreign key constraint
# - created_at: Timestamp indicating when the option was created
# - updated_at: Timestamp indicating the last update to the option
class CreateOptionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.boolean :value
      t.string :description
      t.references :question, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
