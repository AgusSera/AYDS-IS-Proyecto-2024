class Progress < ActiveRecord::Base
  # relacion 1 a 1 con Progress en la tabla Progress
  has_one :user

  def advance_to_next_lesson
    self.current_lesson += 1
    save
  end
end
