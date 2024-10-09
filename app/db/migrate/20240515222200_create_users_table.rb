# OK!

class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :type, null: false, default: 'User'
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.references :progress, foreign_key: true

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end