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

    it "redirects to login page when accessing settings page while not logged in" do
      get '/settings'
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

    it "redirects to dashboard when accessing lesson completed page without completed user id (not logged in)" do
      get '/lesson_completed'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/dashboard')
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

      it "displays the settings page" do
        get '/settings'
        expect(last_response).to be_ok
      end
  
      it "displays the progress/stats page" do
        get '/progress'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq("/progress/")
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
    end

  ##############                      ##############
  ############## Registration process ##############
  ##############                      ##############

    context "registration process" do
      before(:each) do
        # Clear any existing session
        post '/logout'
      end

      after(:each) do
        # Remove the new users created in database
        User.find_by(username: 'newuser123')&.destroy
      end

      it "registers a new user successfully" do
        post '/register', username: 'newuser123', password: 'newpassword123', email: 'newuser123@example.com'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/dashboard')
      end
    
      it "shows an error if the username already exists" do
        User.create(username: 'usuario', password: 'password', email: 'newuser@hola.com')
        post '/register', username: 'usuario', password: 'password', email: 'newuser@hola.com'
        expect(last_response.body).to include('This user already exists.')
      end
    
      it "shows an error if the email already exists" do
        User.create(username: 'uniqueuser', password: 'password', email: 'usuario@example.com')
        post '/register', username: 'newuser', password: 'password', email: 'usuario@example.com'
        expect(last_response.body).to include('This user already exists.')
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
end
