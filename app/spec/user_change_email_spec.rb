# frozen_string_literal: true

RSpec.describe 'Change user email' do
  before(:each) do
    @progress = Progress.create!
    @user = User.create(username: 'user', password: 'password', email: 'old@example.com',
                        progress_id: @progress.id)
    post '/login', username: 'user', password: 'password'
  end

  after(:each) do
    @user.destroy if @user.persisted?
    @progress.destroy if @progress.persisted?
  end

  it 'changes email with correct password' do
    expect(@user.change_email('new@example.com', 'password')).to be_truthy
    expect(@user.reload.email).to eq('new@example.com')
  end

  it 'does not change with incorrect password' do
    expect(@user.change_email('new@example.com', 'wrong')).to be_falsey
    expect(@user.reload.email).to eq('old@example.com')
  end
end
