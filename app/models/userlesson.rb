class UserLesson < ActiveRecord::Base
  # referencia a la relacion N a N entre User y Lesson
  belongs_to :user
  belongs_to :lesson
end

