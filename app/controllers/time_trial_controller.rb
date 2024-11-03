# frozen_string_literal: true

require 'sinatra/base'

require_relative '../helpers'

# TimeTrialController
class TimeTrialController < Sinatra::Base
  helpers Helpers

  set :views, File.expand_path('../views', __dir__)

  get '/timetrial' do
    reset_game_session
    session[:game_started_at] = Time.now.to_i
    redirect '/timetrial/play'
  end

  get '/timetrial/play' do
    @points = session[:points]
    @streak = session[:streak]

    if session[:current_question_id].nil?
      timetrial_questions = Question.where(lesson_id: nil)
      unanswered_questions = timetrial_questions.where.not(id: session[:answered_questions])
      if unanswered_questions.exists?
        session[:current_question_id] = unanswered_questions.sample.id
      else
        # No hay preguntas por responder
        redirect '/timetrial/end_game'
      end
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
    @user = current_user
    progress = @user.progress

    progress.update_progress(session[:points], session[:max_streak])

    @points = session[:points]
    @streak = session[:max_streak]

    reset_game_session

    erb :end_game_time
  end

  def reset_game_session
    session[:streak] = 0
    session[:points] = 0
    session[:answered_questions] = []
    session[:max_streak] = 0
  end
end
