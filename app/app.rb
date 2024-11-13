# frozen_string_literal: true

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

require_relative 'controllers/app_controller'
require_relative 'controllers/user_controller'
require_relative 'controllers/learning_controller'
require_relative 'controllers/time_trial_controller'
require_relative 'controllers/admin_controller'

# The App class serves as the main entry point for the Sinatra application.
class App < Sinatra::Application
  use AppController
  use UserController
  use LearningController
  use TimeTrialController
  use AdminController
end
