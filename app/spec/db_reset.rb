# frozen_string_literal: true

require 'active_record'
require 'yaml'
require 'rake'

# Load the database configuration
db_config = YAML.load_file('config/database.yml')['test']

# Establish connection to the database
ActiveRecord::Base.establish_connection(db_config)

# Load the Rails application tasks
load 'Rakefile'
Rake::Task['db:drop'].invoke
Rake::Task['db:create'].invoke
Rake::Task['db:migrate'].invoke
Rake::Task['db:seed'].invoke
