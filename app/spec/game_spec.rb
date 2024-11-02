# frozen_string_literal: true

RSpec.describe 'Game' do
  context 'play game' do
    before(:each) do
      @progress = Progress.create!
      @user = User.create(username: 'new_user', password: 'password', email: 'email@example.com',
                          progress_id: @progress.id)
      post '/login', username: 'new_user', password: 'password'
    end

    after(:each) do
      # Clean up the database
      User.find_by(username: 'new_user')&.destroy
      Progress.find_by(id: @user.progress.id)&.destroy
    end

    it 'access to completed lesson' do
      @user.progress.update(current_lesson: 3)

      get '/learning/lesson/1/play'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Lesson Completed!')
    end

    it 'access to locked lesson' do
      @user.progress.update(current_lesson: 1)

      get '/learning/lesson/2/play'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Blocked lesson!')
    end

    it 'access to non-existent lesson' do
      get '/learning/lesson/9999/play'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Lesson Not Found')
    end

    it 'access to lesson with questions to answer' do
      @lesson = Lesson.find_by(id: 1)
      @user.progress.update(current_lesson: 1)

      get '/learning/lesson/1/play'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Lesson 1: Variables, Data Types, and Basic Operators')
    end

    it 'select correct answer' do
      @lesson = Lesson.find_by(id: 1)
      @user.progress.update(current_lesson: 1)
      post '/learning/lesson/1/submit_answer', answer: 1
    end

    it 'select wrong answer' do
      @lesson = Lesson.find_by(id: 1)
      @user.progress.update(current_lesson: 1)
      post '/learning/lesson/1/submit_answer', answer: 2
    end
  end
end
