class Lesson < ActiveRecord::Base
  # referencia a la relacion N a N entre User y Lesson
  has_many :user_lessons
  has_many :users, through: :user_lessons
  # referencia a la relacion 1 a N entre Lesson y Question
  has_many :questions
end
