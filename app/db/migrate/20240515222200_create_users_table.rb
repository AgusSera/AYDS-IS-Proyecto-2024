# OK!

class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email
      t.string :password
      t.integer :remaining_life_points, null: false, default: 3
      t.references :progress, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
