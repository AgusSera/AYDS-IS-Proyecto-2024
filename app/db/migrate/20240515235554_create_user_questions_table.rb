# OK!

class CreateUserQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :user_questions do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true
      
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
