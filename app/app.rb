require 'sinatra'
require 'sinatra/activerecord'
require 'rufus-scheduler'
require 'tzinfo'
enable :sessions

ENV['TZ'] = 'America/Argentina/Buenos_Aires'

set :database_file, './config/database.yml'
set :public_folder, 'assets'

require './models/user'
require './models/question'
require './models/option'
require './models/lesson'
require './models/progress'

class App < Sinatra::Application
  configure do
    # Establecer la zona horaria
    Time.zone = 'America/Argentina/Buenos_Aires'
  end

  def initialize(app = nil)
    super()
    start_scheduler
  end

  get '/' do
    if session[:username]
      redirect '/dashboard'
    else
      erb :menu
    end
  end

  #Fixea dirección del css para el browser cuando se juega 
  get '/lesson/:id/play.css' do
    redirect '/play.css'
  end
  
  get '/login' do
    erb :login, locals: { error_message: nil }
  end
  
  post '/login' do
    username = params['username']
    password = params['password']

    if username.empty? || password.empty?
      @error_message = "Username and password are required."
      return erb :login, locals: { error_message: @error_message }
    end

    user = User.find_by(username: username, password: password)

    if user
      session[:username] = user.username
      redirect '/dashboard'
    else
      @error_message = "Incorrect username or password. Please try again."
      erb :login, locals: { error_message: @error_message }
    end
  end  

  post '/logout' do
    session.clear
    redirect '/login'
  end
  
  get '/register' do
    erb :register
  end

  post '/register' do
    username = params['username']
    password = params['password']
    email = params['email']

    if username.empty? || password.empty? || email.empty?
      @error_message = "All fields are required."
      return erb :register
    end

    if User.exists?(username: username)
      @error_message = "Username already exists."
      return erb :register
    end

    if User.exists?(email: email)
      @error_message = "Email already registered."
      return erb :register
    end

    new_progress = Progress.create!
    new_user = User.create(username: username, password: password, email: email, progress_id: new_progress.id)

    if new_user.save
        session[:username] = new_user.username
        redirect '/dashboard'
    else
        @error_message = "There was an error trying to create the account."
        erb :register
    end
  end

  get '/lesson/:id' do
    if session[:username]
      max_lesson_id = Lesson.maximum(:id)
      @lesson = Lesson.find_by(id: params[:id])
      
      if @lesson.nil? || @lesson.id > max_lesson_id
        erb :end_game
      else
        erb :lesson
      end
    else
      redirect '/login'
    end
  end

  get '/lesson/:id/play' do
    if session[:username]
      @lesson = Lesson.find(params[:id])
      @user = User.find_by(username: session[:username])
      progress = @user.progress
    
      if @lesson.id < progress.current_lesson
        erb :lesson_completed
      elsif @lesson.id > progress.current_lesson
        erb :lesson_locked
      elsif @lesson.id == progress.current_lesson
        unanswered_questions = @lesson.questions.where.not(id: progress.correct_answered_questions)
    
        if unanswered_questions.empty?
          progress.advance_to_next_lesson
          session[:completed_user_id] = @user.id
          redirect "/lesson_completed"
        else
          @question = unanswered_questions.sample
          erb :play
        end
      end
    else
      redirect '/login'
    end
  end

  get '/lesson_completed' do
    if session[:completed_user_id]
      @user = User.find(session[:completed_user_id])
      session[:success] = nil
      session[:error] = nil
      erb :lesson_completed
    else
      redirect "/dashboard"
    end
  end

  post '/lesson/:id/submit_answer' do
    lesson = Lesson.find(params[:id])
    user = User.find_by(username: session[:username])
    progress = user.progress

    option = Option.find(params[:answer].to_i)
    question = option.question

    session[:success] = nil
    session[:error] = nil

    if option.value
      handle_correct_answer(progress, question)
    else
      handle_incorrect_answer(user, progress)
    end
  end

  get '/dashboard' do
    if session[:username]
      @user = User.find_by(username: session[:username])
      @lessons = Lesson.all
      erb :dashboard
    else
      redirect '/login'
    end
  end
  
  get '/progress' do
    if session[:username]
      @user = User.find_by(username: session[:username])
      progress = @user.progress 
      erb :progress, locals: { progress: progress, error_message: nil }
    else
      redirect "/login"
    end
  end
  

  get '/settings' do
    if session[:username]
      erb :settings
    else
      redirect '/login'
    end
  end

  post '/change_password' do
    if session[:username]
      user = authenticate_user(session[:username], params[:current_password])
      if user
        result = update_password(user, params[:new_password], params[:confirm_new_password])
        erb :settings, locals: result
      else
        erb :settings, locals: { error_message: "Incorrect current password." }
      end
    else
      redirect '/login'
    end
  end

  post '/change_email' do
    if session[:username]
      user = authenticate_user(session[:username], params[:current_password])
      if user
        result = update_email(user, params[:new_email])
        erb :settings, locals: result
      else
        erb :settings, locals: { error_message: "Incorrect current password." }
      end
    else
      redirect '/login'
    end
  end
  
  post '/reset_progress' do
    if session[:username]
      user = authenticate_user(session[:username], params[:current_password])
      if user
          progress = user.progress
          progress.reset
          @success_message = "Progress reset successfully!"
          erb :settings, locals: { success_message: @success_message }
      else
        @error_message = "Incorrect current password."
        erb :settings, locals: { error_message: @error_message }
      end
    else
      redirect '/login'
    end
  end

  post '/remove_account' do
    if session[:username]
      user = authenticate_user(session[:username], params[:current_password])
      if user
        user.destroy
        session.clear
        redirect '/'
      else
        @error_message = "Incorrect current password."
        erb :settings, locals: { error_message: @error_message }
      end
    else
      redirect '/login'
    end
  end
  
  get '/ranking' do
    if session[:username]
      @ranking_usuarios = obtener_ranking_usuarios
      @current_user = User.find_by(username: session[:username]) if session[:username]
      erb :ranking
    else
      redirect '/login'
    end
  end
end
