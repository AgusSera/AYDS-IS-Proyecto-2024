class Question < ActiveRecord::Base
  # referencia a la relacion N a N entre User y Question
  has_many :user_questions
  has_many :users, through: :user_questions
  # referencia a la relacion 1 a N entre Lesson y Question
  belongs_to :lesson
  # referencia a la relacion 1 a N entre Question y Option
  has_many :options
end
