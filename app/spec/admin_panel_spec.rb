# frozen_string_literal: true

RSpec.describe 'Admin panel' do
  before(:each) do
    # Create a progress record for the user
    @progress = Progress.create!(current_lesson: 1)
  end

  context 'when logged in as an admin' do
    before(:each) do
      # Create an admin user
      @admin_user = Admin.create!(
        username: 'admin_user',
        email: 'admin_user@example.com',
        password: 'password',
        progress: @progress
      )
      post '/login', username: @admin_user.username, password: 'password'
    end

    after(:each) do
      User.find_by(username: 'admin_user')&.destroy
      @progress.destroy
    end

    it 'grants access to the admin panel' do
      get '/admin_panel'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Admin Panel')
    end
  end

  context 'when logged in as a regular user' do
    before(:each) do
      # Create a regular user
      @regular_user = User.create!(
        username: 'regular_user',
        email: 'user@example.com',
        password: 'password',
        progress: @progress
      )
      post '/login', username: @regular_user.username, password: 'password'
    end

    after(:each) do
      User.find_by(username: 'regular_user')&.destroy
      @progress.destroy
    end

    it 'redirects regular users away from the admin panel' do
      get '/admin_panel'
      expect(last_response.status).to eq(302) # Redirect status
      follow_redirect!
      expect(last_request.path).to eq('/dashboard') # Expect redirect to dashboard
    end
  end
end
