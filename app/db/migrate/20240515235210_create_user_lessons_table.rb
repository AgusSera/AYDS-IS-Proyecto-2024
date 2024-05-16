# OK!

class CreateUserLessonsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :user_lessons do |t|
      t.references :user, foreign_key: true
      t.references :lesson, foreign_key: true
      
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
