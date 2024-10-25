# OK!

class CreateOptionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      # OJO!
      t.boolean :value
      t.string :description
      t.references :question, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
