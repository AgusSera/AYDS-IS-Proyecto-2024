class CreateUsersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username, primary_key: true
      t.string :email
      t.string :password

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end