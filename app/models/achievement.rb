class Achievement < ActiveRecord::Base
  # referencia a la relacion 1 a N entre User y Achievement
  belongs_to :user
end
