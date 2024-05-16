# OK!

class CreateAchivementsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :achivements do |t|
      t.string :description
      t.references :user, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
