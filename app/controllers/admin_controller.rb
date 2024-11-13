# frozen_string_literal: true

require 'sinatra/base'

require_relative '../helpers'

# AdminController
class AdminController < Sinatra::Base
  helpers Helpers

  set :views, File.expand_path('../views', __dir__)

  get '/admin_panel' do
    authorize_admin!
    erb :admin_panel
  end

  get '/admin_panel/add_questions' do
    authorize_admin!
    @lessons = Lesson.all
    erb :add_question
  end

  post '/admin_panel/add_questions' do
    @lessons = Lesson.all
    if Question.exists?(description: params['question_description'])
      erb :add_question, locals: { error_message: 'The question already exists' }
    else
      new_question = Question.create(description: params['question_description'], lesson_id: params['lesson_id'])
      (1..4).each do |i|
        is_correct = (params['correct_option'] == i.to_s)
        Option.create(description: params["option_description#{i}"], value: is_correct, question_id: new_question.id)
      end
      erb :add_question, locals: { success_message: 'Question created successfully' }
    end
  end

  get '/admin_panel/top_questions' do
    authorize_admin!
    @n = (params[:n].to_i.positive? ? params[:n].to_i : 5)
    @m = (params[:m].to_i.positive? ? params[:m].to_i : 5)

    @top_incorrect_questions = Question.order(incorrect_answers_count: :desc).limit(@n)

    @top_correct_questions = Question.order(correct_answers_count: :desc).limit(@m)

    erb :top_questions
  end
end
