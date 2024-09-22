ENV['APP_ENV'] = 'test'
require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../app.rb'

RSpec.describe '../app.rb' do
  include Rack::Test::Methods

  def app
    App.new
  end

  
  ############## Endpoints can be accessed successfully ##############
  ##############    and redirects work as expected     ##############
  ##############          while NOT LOGGED IN        ##############

  context "when logged out" do
    before(:each) do
      post '/logout'
      follow_redirect!
    end
    
    it "loads the home page successfully" do
      get '/'
      expect(last_response).to be_ok
    end

    it "loads the login page successfully" do
      get '/login'
      expect(last_response).to be_ok
    end

    it "loads the registration page successfully" do
      get '/register'
      expect(last_response).to be_ok
    end

    ##############  REDIRECTS while NOT LOGGED IN   ##############
    ##############  REDIRECTS while NOT LOGGED IN   ##############

    it "redirects to login page when accessing dashboard while not logged in" do
      get '/dashboard'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when accessing progress page while not logged in" do
      get '/progress'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when accessing ranking page while not logged in" do
      get '/ranking'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when accessing lessons while not logged in" do
      get '/lesson/1'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when accessing lessons while not logged in" do
      get '/lesson/1'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when playing lessons while not logged in" do
      get '/lesson/1/play'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when accessing lesson completed page without completed user id (not logged in)" do
      get '/lesson_completed'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end
  end
  
  ############## Endpoints can be accessed successfully ##############
  ##############    and redirects work as expected     ##############
  ##############          while LOGGED IN        ##############

  context "when logged in" do
      before(:each) do
        # Clear any existing session
        post '/logout'
        
        # Attempt to login
        post '/login', username: 'usuario', password: 'password'
      end
  
      it "displays the dashboard" do
        get '/dashboard'
        expect(last_response).to be_ok
        expect(last_request.path).to eq("/dashboard")
      end

      it "displays the lesson page when accessed from dashboard" do
        # Assuming there's at least one lesson in the database
        lesson = Lesson.first
        get "/lesson/#{lesson.id}"
        expect(last_response).to be_ok
      end

      it "allows users to log out" do
        post '/logout'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq("/login")
      end
  
      
      it "displays the ranking page" do
        get '/ranking'
        expect(last_response).to be_ok
      end
      
      it "redirects to login page if accessing lesson directly without logging in" do
        # Assuming there's at least one lesson in the database
        lesson = Lesson.first
        get "/lesson/#{lesson.id}"
        post '/logout'
        get "/lesson/#{lesson.id}"
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq("/login")
      end

      it "redirects to dashboard when accessing lesson completed page without completed user id (no lesson completed in current session)" do
        get '/lesson_completed'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/dashboard')
      end

      it "redirects to dashboard when trying to reach the main page" do
        get '/'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/dashboard')
      end

      it "redirects to css file when trying to reach it from /lesson/id/play.css" do
        get 'lesson/:id/play.css'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/play.css')
      end

      let!(:lessons) { Lesson.all } 

      context 'when lesson does not exist (nil)' do
        it 'renders the end_game template' do
          get '/lesson/9999'  # id invalido
          expect(last_response).to be_ok
          expect(last_response.body).to include("You have completed all available lessons.")
        end
      end

      context 'when lesson ID is greater than max_lesson_id' do
        it 'renders the end_game template' do
          max_lesson_id = lessons.last.id
          get "/lesson/#{max_lesson_id + 1}"
          expect(last_response).to be_ok
          expect(last_response.body).to include("You have completed all available lessons.")
        end
      end

      context 'when lesson ID is valid' do
        it 'renders the lesson template' do
          lesson = lessons.first
          get "/lesson/#{lesson.id}"
          expect(last_response).to be_ok
          expect(last_response.body).to include("Content of")
        end
      end
    end

  ##############                      ##############
  ##############     Login process    ##############
  ##############                      ##############

    context "login process" do

      after(:each) do
        # Remove the new users created in database
        User.find_by(username: 'newuser123')&.destroy
      end
      
      it "shows an error if the username is empty" do
        post '/login', username: '', password: 'newpassword123'
        expect(last_response.body).to include('Username and password are required.')
      end

      it "shows an error if the password is empty" do
        post '/login', username: 'newuser123', password: ''
        expect(last_response.body).to include('Username and password are required.')
      end

      it "login successfully" do
        progress = Progress.create(
          last_completed_lesson: 0,
          current_lesson: 1,
          numberOfCorrectAnswers: 0.0,
          numberOfIncorrectAnswers: 0.0,
          progressLevel: "Beginner",
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

      it "shows an error if the password is wrong" do
        User.create(username: 'newuser123', password: 'newpassword123', email: 'newuser123@example.com')
        post '/login', username: 'newuser123', password: '12345678'
        expect(last_response.body).to include('Incorrect username or password. Please try again.')
      end

    end  

  ##############                      ##############
  ############## Registration process ##############
  ##############                      ##############

    context "registration process" do
      before(:each) do
        # Clear any existing session
        post '/logout'
        User.find_by(username: 'newuser123')&.destroy
      end

      after(:each) do
        # Remove the new users created in database
        User.find_by(username: 'newuser123')&.destroy
      end

      it "shows an error if the username is empty" do
        post '/register', username: '', password: 'password', email: 'newuser@hola.com'
        expect(last_response.body).to include('All fields are required.')
      end

      it "shows an error if the password is empty" do
        post '/register', username: 'usuario', password: '', email: 'newuser@hola.com'
        expect(last_response.body).to include('All fields are required.')
      end

      it "shows an error if the email is empty" do
        post '/register', username: 'usuario', password: 'password', email: ''
        expect(last_response.body).to include('All fields are required.')
      end

      it "registers a new user successfully" do
        post '/register', username: 'newuser123', password: 'newpassword123', email: 'newuser123@example.com'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/dashboard')
      end
    
      it "shows an error if the username already exists" do
        User.create(username: 'newuser123', password: 'newpassword123', email: 'newuser123@hola.com')
        post '/register', username: 'newuser123', password: 'password', email: 'newuser@hola.com'
        expect(last_response.body).to include('Username already exists.')
      end
    
      it "shows an error if the email already exists" do
        User.create(username: 'newuser123', password: 'password', email: 'usuario@hola.com')
        post '/register', username: 'newuser124', password: 'password', email: 'usuario@hola.com'
        expect(last_response.body).to include('Email already registered.')
      end

      it 'shows an error if the user couldn\'\t be created successfully' do
        allow(User).to receive(:create).and_return(User.new)
        allow_any_instance_of(User).to receive(:save).and_return(false)
      
        post '/register', { username: 'newuser123', password: 'password', email: 'usuario@hola.com' }
      
        expect(last_response).to be_ok
        expect(last_response.body).to include("There was an error trying to create the account.")
      end
      
    end

  ##############                      ##############
  ##############  Lesson progression  ##############
  ##############                      ##############

  context "lesson progression" do
    before(:each) do
      @new_progress = Progress.create!
      @user = User.create(username: 'newuser123', password: 'newpassword123', email: 'newuser123@example.com', progress_id: @new_progress.id)
      post '/login', username: 'newuser123', password: 'newpassword123'
    end
  
    after(:each) do
      # Clean up the database
      User.find_by(username: 'newuser123')&.destroy
      Progress.find_by(id: @user.progress.id)&.destroy
    end
      
    it "redirects to the lesson locked page if the lesson is not unlocked yet" do
      # Assuming @user is already logged in or set up as a new user
      # Set up the next lesson which is supposed to be locked for the user
      next_lesson = Lesson.order(id: :desc).first
      
      # Ensure next_lesson exists
      raise "Next lesson not found" unless next_lesson
    
      # Simulate the user attempting to access a locked lesson
      get "/lesson/#{next_lesson.id}/play"
      
      # Check if the response indicates that the lesson is locked
      expect(last_response.body).to include('locked')
    end

  end

  ##############                        ##############
  ##############  Change user settings  ##############
  ##############                        ##############

  let(:user) { User.create(username: 'testuser', password: 'oldpassword', email: 'oldemail@example.com') }

  describe '#change_password' do
    it 'changes the password when the current password is correct and confirmation matches' do
      result = user.change_password('oldpassword', 'newpassword', 'newpassword')
      expect(result).to be_truthy
      expect(user.reload.password).to eq('newpassword')
    end

    it 'does not change the password if the current password is incorrect' do
      result = user.change_password('wrongpassword', 'newpassword', 'newpassword')
      expect(result).to be_falsey
      expect(user.reload.password).to eq('oldpassword')
    end

    it 'does not change the password if the new password and confirmation do not match' do
      result = user.change_password('oldpassword', 'newpassword', 'differentpassword')
      expect(result).to be_falsey
      expect(user.reload.password).to eq('oldpassword')
    end
  end

  describe '#change_email' do
    it 'changes the email when the current password is correct' do
      result = user.change_email('newemail@example.com', 'oldpassword')
      expect(result).to be_truthy
      expect(user.reload.email).to eq('newemail@example.com')
    end

    it 'does not change the email if the current password is incorrect' do
      result = user.change_email('newemail@example.com', 'wrongpassword')
      expect(result).to be_falsey
      expect(user.reload.email).to eq('oldemail@example.com')
    end
  end

  
  ##############                        ##############
  ##############        Progress        ##############
  ##############                        ##############

  let(:progress) { Progress.create(last_completed_lesson: 0, current_lesson: 1, correct_answered_questions: []) }

  describe '#advance_to_next_lesson' do

    it 'updates progressLevel based on last_completed_lesson' do
      progress.advance_to_next_lesson
      expect(progress.reload.progressLevel).to eq("Junior")
    end
    
    it 'advances to the next lesson' do
      expect { progress.advance_to_next_lesson }.to change { progress.reload.current_lesson }.by(1)
    end

    it 'increases last_completed_lesson by 1' do
      expect { progress.advance_to_next_lesson }.to change { progress.reload.last_completed_lesson }.by(1)
    end

    it 'resets correct_answered_questions to an empty array' do
      progress.update(correct_answered_questions: [1, 2, 3])
      progress.advance_to_next_lesson
      expect(progress.reload.correct_answered_questions).to eq([])
    end

  end


  let(:progress) { Progress.create(numberOfCorrectAnswers: 0) }

  describe '#increase_number_of_correct_answers' do
    it 'increases numberOfCorrectAnswers by 1' do
      expect { progress.increase_number_of_correct_answers }.to change { progress.reload.numberOfCorrectAnswers }.by(1)
    end
  end

  describe '#increase_number_of_incorrect_answers' do
    it 'increases numberOfIncorrectAnswers by 1' do
      expect { progress.increase_number_of_incorrect_answers }.to change { progress.reload.numberOfIncorrectAnswers }.by(1)
    end
  end

  let(:progress) { Progress.create(numberOfCorrectAnswers: 7, numberOfIncorrectAnswers: 3) }

  describe '#calculate_success_rate' do
    it 'calculates the correct success rate' do
      expect(progress.calculate_success_rate).to eq(70.0)
    end

    it 'returns 0 if there are no attempts' do
      progress.update(numberOfCorrectAnswers: 0, numberOfIncorrectAnswers: 0)
      expect(progress.calculate_success_rate).to eq(0.0)
    end
  end

  ##############                        ##############
  ##############          GAME          ##############
  ##############                        ##############

  context "play game" do
    before(:each) do
      @progress = Progress.create!
      @user = User.create(username: 'new_user', password: 'password', email: 'email@example.com', progress_id: @progress.id)
      post '/login', username: 'new_user', password: 'password'
    end
  
    after(:each) do
      # Clean up the database
      User.find_by(username: 'new_user')&.destroy
      Progress.find_by(id: @user.progress.id)&.destroy
    end

    it "access to completed lesson" do
      @user.progress.update(current_lesson: 3)

      get "/lesson/1/play"

      expect(last_response).to be_ok
      expect(last_response.body).to include('Lesson Completed!')
    end

    it "access to locked lesson" do
      @user.progress.update(current_lesson: 1)

      get "/lesson/2/play"

      expect(last_response).to be_ok
      expect(last_response.body).to include('Blocked lesson!')
    end

    it "access to lesson with no questions to answer" do
      @lesson = Lesson.find_by(id: 1)
      @user.progress.update(current_lesson: 1, correct_answered_questions: @lesson.questions)

      get "/lesson/1/play"

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/lesson_completed')
    end

    it "access to lesson with questions to answer" do
      @lesson = Lesson.find_by(id: 1)
      @user.progress.update(current_lesson: 1)

      get "/lesson/1/play"

      expect(last_response).to be_ok
      expect(last_response.body).to include('Lesson 1: Variables, Data Types, and Basic Operators')
    end

    it "select correct answer" do
      @lesson = Lesson.find_by(id: 1)
      @user.progress.update(current_lesson: 1)
      post '/lesson/1/submit_answer', answer:1
    end

    it "select wrong answer" do
      @lesson = Lesson.find_by(id: 1)
      @user.progress.update(current_lesson: 1)
      post '/lesson/1/submit_answer', answer:2
    end
  end

  ##############                             ##############
  ##############        PROGRESS PAGE        ##############
  ##############                             ##############

  context "profile page" do

    before(:each) do
      @progress = Progress.create!
      @user = User.create(username: 'new_user', password: 'password', email: 'new@example.com', progress_id: @progress.id)
      post '/login', username: 'new_user', password: 'password'
    end

    after(:each) do
      User.find_by(username: 'new_user')&.destroy
      @progress.destroy
    end

    it "view profile" do
      get '/profile'
      expect(last_response.body).to include('Información Personal')
    end

  end

  ##############                               ##############
  ##############        CHANGE PASSWORD        ##############
  ##############                               ##############

  context "change password" do

    before(:each) do
      @progress = Progress.create!
      @user = User.create(username: 'new_user', password: 'password', email: 'new@example.com', progress_id: @progress.id)
      post '/login', username: 'new_user', password: 'password'
    end

    after(:each) do
      User.find_by(username: 'new_user')&.destroy
      @progress.destroy
    end

    it "password changed successfully" do
      post '/change_password', current_password: 'password', new_password: 'new_password', confirm_new_password: 'new_password'
      expect(last_response.body).to include('Contraseña actualizada correctamente')
    end

    it "password change unsuccessful" do
      post '/change_password', current_password: 'wrong_password', new_password: 'new_password', confirm_new_password: 'new_password'
      expect(last_response.body).to include('La contraseña actual es incorrecta o las nuevas contraseñas no coinciden.')
    end

  end

  ##############                            ##############
  ##############        CHANGE EMAIL        ##############
  ##############                            ##############

  context "change email" do

    before(:each) do
      @progress = Progress.create!
      @user = User.create(username: 'new_user', password: 'password', email: 'new@example.com', progress_id: @progress.id)
      post '/login', username: 'new_user', password: 'password'
    end

    after(:each) do
      User.find_by(username: 'new_user')&.destroy
      @progress.destroy
    end

    it "email changed successfully" do
      post '/change_email', new_email: 'new@example.com', current_password: 'password'
      expect(last_response.body).to include('Email actualizado correctamente')
    end

    it "email change unsuccessful" do
      post '/change_email', new_email: 'new@example.com', current_password: 'wrong_password'
      expect(last_response.body).to include('La contraseña actual es incorrecta.')
    end

  end

  ##############                                ##############
  ##############        ACCOUNT DELETION        ##############
  ##############                                ##############

  context 'when the user exists' do
    before(:each) do
      @progress = Progress.create!
      @user = User.create(username: 'new_user', password: 'password', email: 'new@example.com', progress_id: @progress.id)
      post '/login', username: 'new_user', password: 'password'
    end

    after(:each) do
      User.find_by(username: 'new_user')&.destroy
      @progress.destroy
    end
  
    it 'renders the settings page with an error message for incorrect password' do
      post '/remove_account', current_password: 'wrongpassword' # incorrect password
  
      expect(last_response.body).to include("Incorrect current password.")
    end
  
    it 'removes the user and clears the session' do
      post '/remove_account', current_password: 'password' # correct password
      
      # checks if the user has been removed
      expect(User.find_by(username: 'new_user')).to be_nil
      
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_response.body).to include('coding') 
    end
  end

  context 'when the user does not exist' do
    before do
      # simulates no user logged in
      post '/logout'
    end

    it 'renders the settings page with an error message' do
      post '/remove_account', current_password: 'any_password'
      
      # checks response to be a redirect
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_response.body).to include("Login")
    end
  end
end
