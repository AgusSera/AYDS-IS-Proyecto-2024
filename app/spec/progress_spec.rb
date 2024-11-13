# frozen_string_literal: true

RSpec.describe 'Progress' do
  let(:progress) { Progress.create(last_completed_lesson: 0, current_lesson: 1, correct_answered_questions: []) }

  describe '#advance_to_next_lesson' do
    it 'updates progressLevel based on last_completed_lesson' do
      progress.advance_to_next_lesson
      expect(progress.reload.progressLevel).to eq('Junior')
    end

    it 'advances to the next lesson' do
      expect { progress.advance_to_next_lesson }.to change { progress.reload.current_lesson }.by(1)
    end

    it 'increases last_completed_lesson by 1' do
      expect { progress.advance_to_next_lesson }.to change { progress.reload.last_completed_lesson }.by(1)
    end

    it 'resets correct_answered_questions to an empty array' do
      progress.update(correct_answered_questions: [1, 2, 3])
      progress.advance_to_next_lesson
      expect(progress.reload.correct_answered_questions).to eq([])
    end

    it 'updates points and streak if new values are higher' do
      progress.update_progress(6, 4)
      expect(progress.points).to eq(6)
      expect(progress.streak).to eq(4)
      progress.update_progress(5, 2)
      expect(progress.points).to eq(6)
      expect(progress.streak).to eq(4)
    end
  end
end
