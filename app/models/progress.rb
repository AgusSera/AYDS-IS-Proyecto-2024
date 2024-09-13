class Progress < ActiveRecord::Base
  # relacion 1 a 1 con Progress en la tabla Progress
  has_one :user

  # Define los niveles de progreso
  PROGRESS_LEVELS = {
    1 => "Junior",
    2 => "Semi-Senior",
    3 => "Senior"
  }

  def act(new_points, new_streak)
    if new_points > self.points
      self.points = new_points
    end

    if new_streak > self.streak
      self.streak = new_streak
    end
    save
  end

  def correct_answer(question_id)
    self.correct_answered_questions = correct_answered_questions << question_id
    self.numberOfCorrectAnswers += 1
    save
  end

  def advance_to_next_lesson
    self.last_completed_lesson += 1
    self.current_lesson += 1
    self.correct_answered_questions = []
    self.progressLevel = calculate_progress_level
    save
  end

  def increase_number_of_correct_answers
    self.numberOfCorrectAnswers += 1
    save
  end

  def increase_number_of_incorrect_answers
    self.numberOfIncorrectAnswers += 1
    save
  end

  def calculate_success_rate
    total_attempts = self.numberOfCorrectAnswers + self.numberOfIncorrectAnswers
    return 0 if total_attempts.zero? # Evitar división por cero
    (self.numberOfCorrectAnswers.to_f / total_attempts) * 100
  end

  def correct_answered_questions
    JSON.parse(read_attribute(:correct_answered_questions))
  end

  def correct_answered_questions=(value)
    write_attribute(:correct_answered_questions, value.to_json)
  end

  private

  # Método privado para calcular el nivel de progreso
  def calculate_progress_level
    PROGRESS_LEVELS[self.last_completed_lesson] || "Beginner"
  end
end

