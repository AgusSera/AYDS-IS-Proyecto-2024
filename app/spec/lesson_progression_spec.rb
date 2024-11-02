# frozen_string_literal: true

RSpec.describe 'Lesson Progression' do
  before(:each) do
    @new_progress = Progress.create!
    @user = User.create(username: 'newuser123', password: 'newpassword123', email: 'newuser123@example.com',
                        progress_id: @new_progress.id)
    post '/login', username: 'newuser123', password: 'newpassword123'
  end

  after(:each) do
    User.find_by(username: 'newuser123')&.destroy
    Progress.find_by(id: @user.progress.id)&.destroy
  end

  it 'redirects to the lesson locked page if the lesson is not unlocked yet' do
    next_lesson = Lesson.order(id: :desc).first
    raise 'Next lesson not found' unless next_lesson

    get "/learning/lesson/#{next_lesson.id}/play"
    expect(last_response.body).to include('locked')
  end

  it 'access to locked lesson' do
    @user.progress.update(current_lesson: 1)
    get '/learning/lesson/2'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Blocked lesson!')
  end
end
