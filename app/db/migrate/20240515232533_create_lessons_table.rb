# OK!

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
