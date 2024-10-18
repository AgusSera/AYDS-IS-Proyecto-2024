require 'sinatra'
require 'sinatra/activerecord'
require_relative 'helpers'
enable :sessions

set :database_file, './config/database.yml'
set :public_folder, 'assets'

require './models/user'
require './models/admin'
require './models/question'
require './models/option'
require './models/lesson'
require './models/progress'

class App < Sinatra::Application

  # Lista de rutas protegidas
  protected_routes = ['/dashboard', '/settings', '/profile', %r{/lesson/.*}, '/lesson_completed', '/progress', '/ranking', '/remove_account', '/reset_progress', '/change_email', '/change_password', '/admin_panel']

  # Tiempo para refill (en segundos)
  REFILL_TIME = 30

  before do
    if protected_routes.any? { |route| route === request.path_info } && session[:username].nil?
      # La ruta está protegida y no hay sesión activa.
      redirect '/login'
    end
  end

  get '/' do
    if session[:username]
      redirect '/dashboard'
    else
      erb :menu
    end
  end

  # Fixea dirección del css para el browser cuando se juega 
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

    user = User.find_by(username: username)

    if user && user.authenticate(password)
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
    max_lesson_id = Lesson.maximum(:id)
    @lesson = Lesson.find_by(id: params[:id])
    
    if @lesson.nil? || @lesson.id > max_lesson_id
      erb :end_game_learn
    else
      erb :lesson
    end
  end

  get '/lesson/:id/play' do
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

    option = Option.find_by(id: params[:answer].to_i)
    question_id = option.question.id

    session[:success] = nil
    session[:error] = nil

    if option.value
      user.progress.correct_answer(question_id)
      session[:success] = 'correct_answer'
    else
      session[:error] = 'wrong_answer'
    end

    redirect "/lesson/#{params[:id]}/play"
  end

  get '/dashboard' do
    welcome_messages = [
      "Choose: learn something new or test your speed in time trial mode. The challenge starts now!",
      "Learning mode or time trial: every choice brings you closer to becoming a better coder. Let’s go!",
      "Ready for the challenge? Learn at your own pace or race against the clock. Choose and start!",
      "Learning or time trial mode? Your coding adventure begins now!"
    ]
  
    @welcome_message = welcome_messages.sample
    
    @user = User.find_by(username: session[:username])
    @lessons = Lesson.all
    erb :dashboard
  end
  
  get '/profile' do
    @user = User.find_by(username: session[:username])
    @progress = @user.progress
    erb :profile
  end

  post '/change_password' do
    @user = User.find_by(username: session[:username])
    @progress = @user.progress
    if @user.change_password(params[:current_password], params[:new_password], params[:confirm_new_password])
      erb :profile, locals: { success_message: "Contraseña actualizada correctamente" }
    else
      erb :profile, locals: { error_message: "La contraseña actual es incorrecta o las nuevas contraseñas no coinciden." }
    end
  end

  post '/change_email' do
    @user = User.find_by(username: session[:username])
    @progress = @user.progress
    if @user.change_email(params[:new_email], params[:current_password])
      erb :profile, locals: { success_message: "Email actualizado correctamente" }
    else
      erb :profile, locals: { error_message: "La contraseña actual es incorrecta." }
    end
  end

  post '/remove_account' do
    @user = User.find_by(username: session[:username])
    @progress = @user.progress
    
    if @user && @user.authenticate(params[:current_password])
      @user.destroy
      session.clear
      redirect '/'
    else
      erb :profile, locals: { error_message: "Incorrect current password." }
    end
  end
  
  get '/ranking' do
    @ranking_usuarios = obtener_ranking_usuarios
    @current_user = User.find_by(username: session[:username]) if session[:username]
    erb :ranking
  end

  get '/timetrial/start_game' do
    session[:streak] = 0
    session[:points] = 0
    session[:answered_questions] = []
    session[:game_started_at] = Time.now.to_i
    session[:max_streak] = 0
    redirect '/timetrial/play'
  end
  
  get '/timetrial/play' do
    @points = session[:points]
    @streak = session[:streak]
  
    if session[:current_question_id].nil?
      timetrial_questions = Question.where(lesson_id: nil)
      unanswered_questions = timetrial_questions.where.not(id: session[:answered_questions])
      session[:current_question_id] = unanswered_questions.sample.id
    end
  
    @question = Question.find(session[:current_question_id])
  
    erb :play_timetrial
  end
  
  post '/timetrial/submit_answer' do
    selected_option_id = params[:answer]
    option = Option.find(selected_option_id)
  
    if option.value
      session[:streak] += 1
      session[:answered_questions] << option.question.id
      session[:points] += 1
  
      session[:max_streak] = session[:streak] if session[:streak] > session[:max_streak]
  
      if session[:streak] > 5
        session[:points] += 1
      end
    else
      session[:streak] = 0
    end
  
    session[:current_question_id] = nil
  
    redirect '/timetrial/play'
  end
  
  get '/end_game_time' do
    @user = User.find_by(username: session[:username])
    progress = @user.progress
  
    progress.act(session[:points], session[:max_streak])
    
    @points = session[:points]
    @streak = session[:max_streak]
  
    session[:streak] = 0
    session[:points] = 0
    session[:answered_questions] = []
    session[:max_streak] = 0
  
    erb :end_game_time
  end

  get '/admin_panel' do
    authorize_admin!
    erb :admin_panel
  end
end
