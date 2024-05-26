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

  def start_scheduler
    scheduler = Rufus::Scheduler.new
    
    scheduler.every '1s' do
      users = User.where('remaining_life_points <= 0 AND updated_at <= ?', 1.minute.ago)
      users.each do |user|
        user.update(remaining_life_points: [user.remaining_life_points + 3, 0].max) # El usuario recupera las vidas.
      end
    end
  end

  get '/' do
    erb :menu
  end

  get '/login' do
    erb :login, locals: { error_message: nil }
  end
  
  post '/login' do
    user = User.find_by(username: params[:username], password: params[:password])
    if user
      session[:username] = user.username
      redirect '/dashboard'
    else
      @error_message = "Incorrect username of password. Please try again."
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

    if User.exists?(username: username) || User.exists?(email: email)
      @error_message = "A user with that username already exists."
      erb :register
    else
      new_progress = Progress.create(current_lesson: 1) # Progreso asociado al nuevo usuario
      new_user = User.new(username: username, password: password, email: email, remaining_life_points: 3, progress_id: new_progress.id)
      if new_user.save
        session[:username] = new_user.username
        redirect '/dashboard'
      else
        @error_message = "There was an error trying to create the account."
        erb :register
      end
    end
  end

  get '/users' do
    @users = User.all
    erb :'users/index'
  end

  get '/users/:username' do
    user = User.find_by(username: params[:username])
    if user
      response = "<p>Username: #{user.username}</p>"
      response += "<p>E-mail: #{user.email}</p>"
      response
    else
      status 404 
      "User not found"
    end
  end

  get '/question/:id' do
    @question = Question.find_by(id: params[:id])
    if @question
      @options = @question.options
      erb :question
    else
      "Question not found"
    end
  end

  get '/lesson/:id' do
    @lesson = Lesson.find(params[:id])
    if session[:username]
      erb :lesson
    else
      redirect '/login'
    end
  end

  get '/lesson/:id/content' do
    @lesson = Lesson.find(params[:id])
    erb :content
  end

  get '/lesson/:id/play' do
    @lesson = Lesson.find(params[:id])
    @user = User.find_by(username: session[:username])
    progress = @user.progress 

    # Acceder a una lección ya completada
    if @lesson.id < progress.current_lesson
      erb :lesson_completed
    # Acceder a lección alcanzada por el usuario
    elsif @lesson.id == progress.current_lesson
      session[:answered_questions] ||= []
      unanswered_questions = @lesson.questions.where.not(id: session[:answered_questions])

      if unanswered_questions.empty? # No hay preguntas sin responder
        progress.update(current_lesson: progress.current_lesson + 1) # El usuario avanza a la lección siguiente
        erb :lesson_completed
      else
        @question = unanswered_questions.sample # Obtener pregunta aleatoria
        erb :play
      end
    else # Acceder a lección no alcanzada
      erb :lesson_locked
    end
  end

  post '/lesson/:id/submit_answer' do
    @lesson = Lesson.find(params[:id])
    @user = User.find_by(username: session[:username])
    progress = @user.progress 

    option_id = params[:answer].to_i
    option = Option.find(option_id)
    question_id = option.question.id
    question = Question.find(question_id)
    
    if option.value
      # Respuesta correcta
      session[:answered_questions] << question_id
      # Seguir respondiendo preguntas de la lección
      redirect "/lesson/#{params[:id]}/play"
    else
      # Respuesta incorrecta
      redirect "/lesson/#{params[:id]}/play?error=wrong_answer"
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
    redirect "/progress/#{params[:id]}"
  end
  
  get '/progress/:id' do
    progress = Progress.find_by(id: params[:id])
    if progress
      erb :progress, locals: { progress: progress, error_message: nil }
    else
      erb :progress, locals: { progress: nil, error_message: "Progress not found" }
    end
  end
  

end
