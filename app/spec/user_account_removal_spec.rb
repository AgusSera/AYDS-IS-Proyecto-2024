# frozen_string_literal: true

RSpec.describe 'User account removal' do
  before(:each) do
    @progress = Progress.create!
    @user = User.create(username: 'user', password: 'password', email: 'email@example.com',
                        progress_id: @progress.id)
    post '/login', username: 'user', password: 'password'
  end

  after(:each) do
    @user.destroy if @user.persisted?
    @progress.destroy if @progress.persisted?
  end

  it 'removes user with correct password and clears the session' do
    post '/user/remove_account', current_password: 'password'
    expect(User.find_by(username: 'user')).to be_nil
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_response.body).to include('coding')
  end

  it 'renders the settings page with an error message for incorrect password' do
    post '/user/remove_account', current_password: 'wrongpassword'
    expect(last_response.body).to include('Incorrect current password.')
  end
end
