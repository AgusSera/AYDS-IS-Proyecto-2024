# frozen_string_literal: true

# Migration to create the users table. This table stores user information,
# including the user's type, username, email, and password_digest for authentication.
# Fields:
# - type: Specifies the type of user, defaults to 'User'. It can be Admin or User
# - username: Stores the unique username of the user
# - email: Stores the unique email address of the user
# - password_digest: Stores the password hash for secure authentication
# - progress_id: References the user's progress, with a foreign key constraint
# Indexes:
# - Adds unique indexes on username and email to prevent duplicates
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
