require 'sinatra'

get '/login' do
  erb :login
end

post '/login' do
  username = params['uname']
  "Hola #{username}."
end
