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
    
    scheduler.every '5s' do
      users = User.where('remaining_life_points <= 0 AND updated_at <= ?', 1.minute.ago)
      users.each do |user|
        user.update(remaining_life_points: [user.remaining_life_points + 3, 0].max) # El usuario recupera las vidas.
      end
    end
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
    user = User.find_by(username: params[:username], password: params[:password])
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

    if User.exists?(username: username) || User.exists?(email: email)
      @error_message = "This user already exists."
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

  get '/lesson/:id/content' do
    @lesson = Lesson.find(params[:id])
    erb :content
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
        progress.save
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
    @lesson = Lesson.find(params[:id])
    @user = User.find_by(username: session[:username])
    progress = @user.progress 
  
    option_id = params[:answer].to_i
    option = Option.find(option_id)
    question_id = option.question.id
    question = Question.find(question_id)
    session[:success] = nil
    session[:error] = nil
    
    if option.value
      correct_questions = progress.correct_answered_questions
      correct_questions << question_id unless correct_questions.include?(question_id)
      progress.correct_answered_questions = correct_questions
      progress.increase_number_of_correct_answers
      progress.save
  
      session[:success] = 'correct_answer'
      redirect "/lesson/#{params[:id]}/play"
    else
      progress.increase_number_of_incorrect_answers
      @user.subtract_life_point
      if @user.remaining_life_points <= 0
        session[:error] = 'no_lives_remaining'
        redirect "/lesson/#{params[:id]}/play"
      else
        session[:error] = 'wrong_answer'
        redirect "/lesson/#{params[:id]}/play"
      end
    end
  end

  get '/dashboard' do
    if session[:username]
      @user = User.find_by(username: session[:username])
      @lessons = Lesson.all
      session[:answered_questions] = nil
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

  get '/settings' do
    if session[:username]
      erb :settings
    else
      redirect '/'
    end
  end

  post '/change_password' do
    if session[:username]
      user = User.find_by(username: session[:username], password: params[:current_password])
      if user
        if params[:new_password] == params[:confirm_new_password]
          user.update(password: params[:new_password])
          user.save
          @success_message = "Password changed successfully!"
          erb :settings, locals: { success_message: @success_message }
        else
          @error_message = "New password and confirm password do not match."
          erb :settings, locals: { error_message: @error_message }
        end
      else
        @error_message = "Incorrect current password."
        erb :settings, locals: { error_message: @error_message }
      end
    else
      redirect '/login'
    end
  end

  post '/change_email' do
    if session[:username]
      user = User.find_by(username: session[:username], password: params[:current_password])
      if user
          user.update(email: params[:new_email])
          user.save
          @success_message = "Email changed successfully!"
          erb :settings, locals: { success_message: @success_message }
      else
        @error_message = "Incorrect current password."
        erb :settings, locals: { error_message: @error_message }
      end
    else
      redirect '/login'
    end
  end
  
  post '/reset_progress' do
    if session[:username]
      user = User.find_by(username: session[:username], password: params[:current_password])
      if user
          progress = user.progress
          progress.reset
          session[:answered_questions] = []
          @success_message = "Reset progress successfully!"
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
      user = User.find_by(username: session[:username], password: params[:current_password])
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

  def obtener_ranking_usuarios
    usuarios = User.all.to_a  # Convertir la relación ActiveRecord a una matriz
    usuarios.sort_by do |usuario|
      [-usuario.progress.last_completed_lesson, -usuario.progress.calculate_success_rate]
    end
  end
  
  get '/ranking' do
    @ranking_usuarios = obtener_ranking_usuarios
    @current_user = User.find_by(username: session[:username]) if session[:username]
    erb :ranking
  end

end
