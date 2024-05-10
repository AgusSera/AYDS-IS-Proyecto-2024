require 'sinatra'
require 'sinatra/activerecord'

set :database_file, './config/database.yml'

require './models/user'

class App < Sinatra::Application
  def initialize(app = nil)
    super()
  end

  get '/' do
    erb :menu
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    username = params['uname']
    "Hola #{username}."
  end

  post '/login_redirect' do
    redirect '/login'
  end

  get '/users' do
    @users = User.all
    erb :'users/index'
  end

  get '/users/:username' do
    user = User.find_by(username: params[:username])
    if user
      response = "<p>Username: #{user.username}</p>"
    response += "<p>Name: #{user.names}</p>"
    response += "<p>E-mail: #{user.email}</p>"
      response
    else
      status 404 
      "User not found"
    end
  end
end
