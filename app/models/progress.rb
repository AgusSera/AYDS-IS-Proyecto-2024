class Progress < ActiveRecord::Base
  # relacion 1 a 1 con Progress en la tabla Progress
  has_one :user

  def advance_to_next_lesson
    self.current_lesson += 1
    save
  end

  def increase_number_of_correct_answers
    self.numberOfCorrectAnswers += 5
    save
  end
end
