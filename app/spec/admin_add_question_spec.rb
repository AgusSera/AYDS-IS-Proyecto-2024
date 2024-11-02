# frozen_string_literal: true

RSpec.describe 'Add Question feature', type: :feature do
  before do
    @lesson = Lesson.create(name: 'Lesson 1')
    @existing_question = Question.create(description: 'Existing question', lesson_id: @lesson.id)
  end

  after do
    Question.find_by(description: 'Existing question')&.destroy
    post '/logout'
  end

  context 'when logged in as an admin' do
    before(:each) do
      @progress = Progress.create!(current_lesson: 1)
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

    it 'accesses the question form' do
      get '/admin_panel/add_questions'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Form to Add Question')
    end

    it 'shows an error if the question already exists' do
      post '/admin_panel/add_questions', question_description: @existing_question.description, lesson_id: @lesson.id
      expect(last_response).to be_ok
      expect(last_response.body).to include('The question already exists')
      expect(Question.where(description: @existing_question.description).count).to eq(1)
    end

    it 'creates a new question successfully' do
      post '/admin_panel/add_questions', {
        question_description: 'What is the result of 3 == 4 in Python?',
        lesson_id: @lesson.id,
        correct_option: '3',
        option_description1: 'True',
        option_description2: 'None',
        option_description3: 'False',
        option_description4: 'Error'
      }

      expect(last_response).to be_ok
      expect(last_response.body).to include('Question created successfully')

      new_question = Question.find_by(description: 'What is the result of 3 == 4 in Python?')
      expect(new_question).not_to be_nil

      options = Option.where(question_id: new_question.id)
      expect(options.count).to eq(4)
      expect(options.find_by(description: 'False').value).to be true
      expect(options.find_by(description: 'True').value).to be false
    end
  end
end
