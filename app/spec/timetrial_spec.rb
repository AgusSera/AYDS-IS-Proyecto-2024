# frozen_string_literal: true

RSpec.describe 'Time Trial game mode' do
  context 'play game' do
    before(:each) do
      @progress = Progress.create!
      @user = User.create(username: 'new_user', password: 'password', email: 'new@example.com',
                          progress_id: @progress.id)
      post '/login', username: 'new_user', password: 'password'
    end

    after(:each) do
      User.find_by(username: 'new_user')&.destroy
      @progress.destroy
    end

    it 'initializes the game session' do
      get '/timetrial'
      expect(last_response).to be_redirect
      follow_redirect!
    end

    it 'finalizes the game and resets the session variables' do
      get '/timetrial/end_game', { 'rack.session' => { streak: 6, points: 0 } }
      expect(last_response).to be_ok
      expect(last_response.body).to include('Game over!')
    end

    it 'select correct answer' do
      post '/timetrial/submit_answer', { answer: 121 },
           { 'rack.session' => { streak: 6, max_streak: 0, points: 0, answered_questions: [] } }
    end

    it 'select wrong answer' do
      post '/timetrial/submit_answer', answer: 122
    end

    it 'redirects to end_game when there are no unanswered questions' do
      session_data = { answered_questions: Question.where(lesson_id: nil).pluck(:id) }
      get '/timetrial/play', {}, 'rack.session' => session_data
      expect(last_response).to be_redirect
      expect(last_response.location).to include('/timetrial/end_game')
    end
  end
end
