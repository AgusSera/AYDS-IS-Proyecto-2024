# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_16_004929) do
  create_table 'lessons', force: :cascade do |t|
    t.string 'name'
    t.string 'content'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'options', force: :cascade do |t|
    t.boolean 'value'
    t.string 'description'
    t.integer 'question_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index ['question_id'], name: 'index_options_on_question_id'
  end

  create_table 'progresses', force: :cascade do |t|
    t.integer 'last_completed_lesson', default: 0, null: false
    t.integer 'current_lesson', default: 1, null: false
    t.string 'progressLevel', default: 'Beginner', null: false
    t.text 'correct_answered_questions', default: '[]'
    t.integer 'points', default: 0, null: false
    t.integer 'streak', default: 0, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'questions', force: :cascade do |t|
    t.string 'description'
    t.integer 'lesson_id'
    t.integer 'correct_answers_count', default: 0
    t.integer 'incorrect_answers_count', default: 0
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index ['lesson_id'], name: 'index_questions_on_lesson_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'type', default: 'User', null: false
    t.string 'username', null: false
    t.string 'email', null: false
    t.string 'password_digest', null: false
    t.integer 'progress_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['progress_id'], name: 'index_users_on_progress_id'
    t.index ['username'], name: 'index_users_on_username', unique: true
  end

  add_foreign_key 'options', 'questions'
  add_foreign_key 'questions', 'lessons'
  add_foreign_key 'users', 'progresses'
end
