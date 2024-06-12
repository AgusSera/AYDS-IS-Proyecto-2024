require 'bundler/setup'
Bundler.require

require 'sinatra/activerecord'
require './app'

# Load the database configuration
database_config = YAML.load_file('config/database.yml')

# Set the environment for Active Record
ActiveRecord::Base.establish_connection(database_config[ENV['RACK_ENV'] || 'development'])
