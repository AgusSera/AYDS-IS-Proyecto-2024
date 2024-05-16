class Achivement < ActiveRecord::Base
  # referencia a la relacion 1 a N entre User y Achivement
  belongs_to :user
end
