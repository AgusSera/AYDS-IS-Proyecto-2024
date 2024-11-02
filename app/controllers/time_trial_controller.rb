# frozen_string_literal: true

require 'sinatra/base'

require_relative '../helpers'

# TimeTrialController
class TimeTrialController < Sinatra::Base
  helpers Helpers

  set :views, File.expand_path('../views', __dir__)

  get '/timetrial' do
    session[:streak] = 0
    session[:points] = 0
    session[:answered_questions] = []
    session[:game_started_at] = Time.now.to_i
    session[:max_streak] = 0
    redirect '/timetrial/play'
  end

  get '/timetrial/play' do
    @points = session[:points]
    @streak = session[:streak]

    if session[:current_question_id].nil?
      timetrial_questions = Question.where(lesson_id: nil)
      unanswered_questions = timetrial_questions.where.not(id: session[:answered_questions])
      session[:current_question_id] = unanswered_questions.sample.id
    end

    @question = Question.find(session[:current_question_id])

    erb :play_timetrial
  end

  post '/timetrial/submit_answer' do
    selected_option_id = params[:answer]
    option = Option.find(selected_option_id)
    question = option.question

    if option.value
      session[:success] = 'correct_answer'
      question.increment!(:correct_answers_count)
      session[:streak] += 1
      session[:answered_questions] << option.question.id
      session[:points] += 1

      session[:max_streak] = session[:streak] if session[:streak] > session[:max_streak]

      session[:points] += 1 if session[:streak] > 5
    else
      session[:error] = 'wrong_answer'
      question.increment!(:incorrect_answers_count)
      session[:streak] = 0
    end

    session[:current_question_id] = nil

    redirect '/timetrial/play'
  end

  get '/timetrial/end_game' do
    @user = User.find_by(username: session[:username])
    progress = @user.progress

    progress.act(session[:points], session[:max_streak])

    @points = session[:points]
    @streak = session[:max_streak]

    session[:streak] = 0
    session[:points] = 0
    session[:answered_questions] = []
    session[:max_streak] = 0

    erb :end_game_time
  end
end
