# frozen_string_literal: true

RSpec.describe 'Show Top Questions feature', type: :feature do
  before(:each) do
    @lesson = Lesson.create(name: 'Test Lesson', content: 'Content for test lesson')
    @question1 = Question.create(description: 'Question with more incorrect answers', lesson_id: @lesson.id,
                                 correct_answers_count: 2, incorrect_answers_count: 10)
    @question2 = Question.create(description: 'Question with more correct answers', lesson_id: @lesson.id,
                                 correct_answers_count: 10, incorrect_answers_count: 2)

    @progress = Progress.create!(current_lesson: 1)
    @admin_user = Admin.create!(
      username: 'admin_test',
      email: 'admin_test@example.com',
      password: 'password',
      progress: @progress
    )
    post '/login', username: 'admin', password: 'password'
  end

  it 'displays the top questions on /admin_panel/top_questions' do
    get '/admin_panel/top_questions', n: 1, m: 1
    expect(last_response).to be_ok
    expect(last_response.body).to include(@question1.description)
    expect(last_response.body).to include(@question2.description)
  end

  after(:each) do
    @question1.destroy
    @question2.destroy
    @lesson.destroy
    User.find_by(username: 'admin_test')&.destroy
    @progress.destroy
  end
end
