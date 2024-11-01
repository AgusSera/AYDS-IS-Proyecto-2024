# frozen_string_literal: true

# Option model
class Option < ActiveRecord::Base
  # referencia a la relacion 1 a N entre Question y Option
  belongs_to :question
end
