class User < ActiveRecord::Base
  # CF de la relacion 1 a 1 con Progress en la tabla Progress
  belongs_to :progress

  def subtract_life_point
    self.remaining_life_points -= 1
    save
  end
end
