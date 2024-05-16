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
  create_table "achivements", force: :cascade do |t|
    t.string "description"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_achivements_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name"
    t.string "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", force: :cascade do |t|
    t.boolean "value"
    t.string "description"
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "progresses", force: :cascade do |t|
    t.integer "numberOfCorrectAnswers"
    t.integer "numberOfAchivements"
    t.string "progressLevel"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_progresses_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "description"
    t.integer "lesson_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["lesson_id"], name: "index_questions_on_lesson_id"
  end

  create_table "user_lessons", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lesson_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["lesson_id"], name: "index_user_lessons_on_lesson_id"
    t.index ["user_id"], name: "index_user_lessons_on_user_id"
  end

  create_table "user_questions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_user_questions_on_question_id"
    t.index ["user_id"], name: "index_user_questions_on_user_id"
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string "username", null: false
    t.string "email"
    t.string "password"
    t.integer "remaining_life_points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "achivements", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "progresses", "users"
  add_foreign_key "questions", "lessons"
  add_foreign_key "user_lessons", "lessons"
  add_foreign_key "user_lessons", "users"
  add_foreign_key "user_questions", "questions"
  add_foreign_key "user_questions", "users"
end
