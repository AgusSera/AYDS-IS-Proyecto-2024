# frozen_string_literal: true

# Question model
class Question < ActiveRecord::Base
  # referencia a la relacion 1 a N entre Lesson y Question
  belongs_to :lesson
  # referencia a la relacion 1 a N entre Question y Option
  has_many :options
end
