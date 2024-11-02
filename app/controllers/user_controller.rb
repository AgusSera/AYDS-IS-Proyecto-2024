# frozen_string_literal: true

require 'sinatra/base'

require_relative '../helpers'

# UseController
class UserController < Sinatra::Base
  helpers Helpers

  set :views, File.expand_path('../views', __dir__)

  get '/user/profile' do
    @user = User.find_by(username: session[:username])
    @progress = @user.progress
    erb :profile
  end

  post '/user/change_password' do
    @user = User.find_by(username: session[:username])
    @progress = @user.progress
    if @user.change_password(params[:current_password], params[:new_password], params[:confirm_new_password])
      erb :profile, locals: { success_message: 'Contraseña actualizada correctamente' }
    else
      erb :profile,
          locals: { error_message: 'La contraseña actual es incorrecta o las nuevas contraseñas no coinciden.' }
    end
  end

  post '/user/change_email' do
    @user = User.find_by(username: session[:username])
    @progress = @user.progress
    if @user.change_email(params[:new_email], params[:current_password])
      erb :profile, locals: { success_message: 'Email actualizado correctamente' }
    else
      erb :profile, locals: { error_message: 'La contraseña actual es incorrecta.' }
    end
  end

  post '/user/remove_account' do
    @user = User.find_by(username: session[:username])
    @progress = @user.progress

    if @user&.authenticate(params[:current_password])
      @user.destroy
      session.clear
      redirect '/'
    else
      erb :profile, locals: { error_message: 'Incorrect current password.' }
    end
  end

  get '/ranking' do
    @ranking_usuarios = obtener_ranking_usuarios
    @current_user = User.find_by(username: session[:username]) if session[:username]
    erb :ranking
  end
end
