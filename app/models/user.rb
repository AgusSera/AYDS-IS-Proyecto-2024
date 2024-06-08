class User < ActiveRecord::Base
  # referencia a la relacion N a N entre User y Lesson
  has_many :user_lessons
  has_many :lessons, through: :user_lessons
  # referencia a la relacion N a N entre User y Question
  has_many :user_questions
  has_many :questions, through: :user_questions
  # referencia a la relacion 1 a N entre User y Achievement
  has_many :achievements
  # CF de la relacion 1 a 1 con Progress en la tabla Progress
  belongs_to :progress
  # TODO? relacion con Ranking
  # TODO? relacion con ChosenOption
  def subtract_life_point
    self.remaining_life_points -= 1
    save
  end
end
