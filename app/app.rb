require 'sinatra/base'

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
end
