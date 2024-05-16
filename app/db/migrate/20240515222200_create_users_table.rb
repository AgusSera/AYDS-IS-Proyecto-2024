# OK!

class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: false, primary_key: :username do |t|
      t.string :username, null: false
      t.string :email
      t.string :password
      t.integer :remaining_life_points

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
