# frozen_string_literal: true

class Progress < ActiveRecord::Base
  # relacion 1 a 1 con Progress en la tabla Progress
  has_one :user

  # Define los niveles de progreso
  PROGRESS_LEVELS = {
    1 => 'Junior',
    2 => 'Semi-Senior',
    3 => 'Senior'
  }.freeze

  def act(new_points, new_streak)
    new_points ||= 0
    new_streak ||= 0

    self.points = new_points if new_points > points

    self.streak = new_streak if new_streak > streak
    save
  end

  def correct_answer(question_id)
    self.correct_answered_questions = correct_answered_questions << question_id
    save
  end

  def advance_to_next_lesson
    self.last_completed_lesson += 1
    self.current_lesson += 1
    self.correct_answered_questions = []
    self.progressLevel = calculate_progress_level
    save
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
    PROGRESS_LEVELS[self.last_completed_lesson] || 'Beginner'
  end
end
