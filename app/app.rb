require 'sinatra/base'

class App < Sinatra::Application
  def initialize(app = nil)
    super()
  end

  get '/' do
    'Welcome'
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    username = params['uname']
    "Hola #{username}."
  end
end
