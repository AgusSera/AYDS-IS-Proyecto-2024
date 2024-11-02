# frozen_string_literal: true

require 'sinatra/base'

require_relative '../helpers'

# AppController
class AppController < Sinatra::Base
  helpers Helpers

  set :views, File.expand_path('../views', __dir__)

  # Lista de rutas protegidas
  protected_routes = ['/dashboard', %r{/user/.*}, %r{/learning/.*}, '/ranking', %r{/admin_panel/?.*},
                      %r{/timetrial/.*}]

  before do
    if protected_routes.any? do |route|
      route.is_a?(String) ? (request.path_info == route) : route.match(request.path_info)
    end && session[:username].nil?
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

  get '/login' do
    erb :login, locals: { error_message: nil }
  end

  post '/login' do
    username = params['username']
    password = params['password']

    if username.empty? || password.empty?
      @error_message = 'Username and password are required.'
      return erb :login, locals: { error_message: @error_message }
    end

    user = User.find_by(username: username)

    if user&.authenticate(password)
      session[:username] = user.username
      redirect '/dashboard'
    else
      @error_message = 'Incorrect username or password. Please try again.'
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
      @error_message = 'All fields are required.'
      return erb :register
    end

    if User.exists?(username: username)
      @error_message = 'Username already exists.'
      return erb :register
    end

    if User.exists?(email: email)
      @error_message = 'Email already registered.'
      return erb :register
    end

    new_progress = Progress.create!
    new_user = User.create(username: username, password: password, email: email, progress_id: new_progress.id)

    if new_user.save
      session[:username] = new_user.username
      redirect '/dashboard'
    else
      @error_message = 'There was an error trying to create the account.'
      erb :register
    end
  end

  get '/dashboard' do
    welcome_messages = [
      'Choose: learn something new or test your speed in time trial mode. The challenge starts now!',
      'Learning mode or time trial: every choice brings you closer to becoming a better coder. Let’s go!',
      'Ready for the challenge? Learn at your own pace or race against the clock. Choose and start!',
      'Learning or time trial mode? Your coding adventure begins now!'
    ]

    @welcome_message = welcome_messages.sample

    @user = User.find_by(username: session[:username])
    @lessons = Lesson.all
    erb :dashboard
  end
end
