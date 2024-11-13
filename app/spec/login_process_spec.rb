# frozen_string_literal: true

RSpec.describe 'Login Process' do
  after(:each) do
    # Remove the new users created in database
    User.find_by(username: 'newuser123')&.destroy
  end

  it 'shows an error if the username is empty' do
    post '/login', username: '', password: 'newpassword123'
    expect(last_response.body).to include('Username and password are required.')
  end

  it 'shows an error if the password is empty' do
    post '/login', username: 'newuser123', password: ''
    expect(last_response.body).to include('Username and password are required.')
  end

  it 'login successfully' do
    progress = Progress.create(
      last_completed_lesson: 0,
      current_lesson: 1,
      progressLevel: 'Beginner',
      correct_answered_questions: '[]'
    )

    User.create(
      username: 'newuser123',
      password: 'newpassword123',
      email: 'newuser123@example.com',
      progress: progress
    )
    post '/login', username: 'newuser123', password: 'newpassword123'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/dashboard')
  end

  it 'shows an error if the password is wrong' do
    User.create(username: 'newuser123', password: 'newpassword123', email: 'newuser123@example.com')
    post '/login', username: 'newuser123', password: '12345678'
    expect(last_response.body).to include('Incorrect username or password. Please try again.')
  end
end
