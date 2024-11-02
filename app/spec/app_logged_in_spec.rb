# frozen_string_literal: true

RSpec.describe 'App Logged In' do
  context 'when logged in' do
    before(:each) do
      post '/logout'
      post '/login', username: 'usuario', password: 'password'
    end

    it 'displays the dashboard' do
      get '/dashboard'
      expect(last_response).to be_ok
      expect(last_request.path).to eq('/dashboard')
    end

    it 'displays the ranking page' do
      get '/ranking'
      expect(last_response).to be_ok
    end

    it 'allows users to log out' do
      post '/logout'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it 'displays the lesson page when accessed from dashboard' do
      # Assuming there's at least one lesson in the database
      lesson = Lesson.first
      get "/learning/lesson/#{lesson.id}"
      expect(last_response).to be_ok
    end

    it 'redirects to dashboard when trying to reach the main page' do
      get '/'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/dashboard')
    end

    let!(:lessons) { Lesson.all }

    context 'when lesson does not exist (nil)' do
      it 'renders the end_game template' do
        get '/learning/lesson/9999' # id invalido
        expect(last_response).to be_ok
        expect(last_response.body).to include('Lesson Not Found')
      end
    end

    context 'when lesson ID is greater than max_lesson_id' do
      it 'renders the end_game template' do
        max_lesson_id = lessons.last.id
        get "/learning/lesson/#{max_lesson_id + 1}"
        expect(last_response).to be_ok
        expect(last_response.body).to include('Lesson Not Found')
      end
    end

    context 'when lesson ID is valid' do
      it 'renders the lesson template' do
        lesson = lessons.first
        get "/learning/lesson/#{lesson.id}"
        expect(last_response).to be_ok
        expect(last_response.body).to include('Content of')
      end
    end
  end
end
