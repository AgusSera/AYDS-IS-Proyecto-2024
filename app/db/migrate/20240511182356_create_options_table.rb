class CreateOptionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :options, id: false do |t|
      t.integer :id
      t.string :description
      t.boolean :correct

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
