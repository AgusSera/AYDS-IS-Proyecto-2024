# frozen_string_literal: true

RSpec.describe 'Profile page' do
  context 'profile page' do
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

    it 'view profile' do
      get '/user/profile'
      expect(last_response.body).to include('Personal information')
    end
  end
end
