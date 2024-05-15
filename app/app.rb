require 'sinatra'
require 'sinatra/activerecord'
enable :sessions

set :database_file, './config/database.yml'

require './models/user'
require './models/question'

class App < Sinatra::Application
  def initialize(app = nil)
    super()
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
      @error_message = "Usuario o contraseña incorrectos."
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
      @error_message = "Usuario ya existente."
      erb :register
    else
      new_user = User.new(username: username, password: password, email: email)
      if new_user.save
        session[:username] = new_user.username
        redirect '/dashboard'
      else
        @error_message = "Hubo un error al intentar crear la cuenta."
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
    question = Question.find_by(id: params[:id])
    if question
      "#{question.description}"
    else
      "Question not found"
    end
  end

  get '/dashboard' do
    if session[:username]
      @user = User.find_by(username: session[:username])
      erb :dashboard
    else
      redirect '/login'
    end
  end
  
  get '/progress/:id?' do
    progress = Progress.find_by(id: params[:id])
    if progress
      "#{progress.numberOfCorrectAnswers}"
      "#{progress.numberOfAchivements}"
      "#{progress.progressLevel}"
    else
      "Progress not found"
    end
  end

end
