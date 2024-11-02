# frozen_string_literal: true

require 'sinatra/base'

require_relative '../helpers'

# LearningController
class LearningController < Sinatra::Base
  helpers Helpers

  set :views, File.expand_path('../views', __dir__)

  get '/learning/lesson/:id' do
    @user = User.find_by(username: session[:username])
    progress = @user.progress

    lesson_id = params[:id].to_i
    max_lesson_id = Lesson.maximum(:id)

    if lesson_id > max_lesson_id || lesson_id <= 0
      erb :lesson_not_found
    elsif lesson_id > progress.current_lesson
      erb :lesson_locked
    else
      @lesson = Lesson.find_by(id: lesson_id)
      erb :lesson
    end
  end

  get '/learning/lesson/:id/play' do
    @user = User.find_by(username: session[:username])
    progress = @user.progress

    max_lesson_id = Lesson.maximum(:id)
    lesson_id = params[:id].to_i

    if lesson_id > max_lesson_id || lesson_id <= 0
      erb :lesson_not_found
    elsif lesson_id < progress.current_lesson
      erb :lesson_completed
    elsif lesson_id > progress.current_lesson
      erb :lesson_locked
    else
      @lesson = Lesson.find(params[:id])
      unanswered_questions = @lesson.questions.where.not(id: progress.correct_answered_questions)

      if unanswered_questions.empty?
        progress.advance_to_next_lesson
        session[:completed_user_id] = @user.id
        redirect '/learning/lesson_completed'
      else
        @question = unanswered_questions.sample
        erb :play
      end
    end
  end

  get '/learning/lesson_completed' do
    if session[:completed_user_id]
      @user = User.find(session[:completed_user_id])
      session[:success] = nil
      session[:error] = nil
      erb :lesson_completed
    else
      redirect '/dashboard'
    end
  end

  post '/learning/lesson/:id/submit_answer' do
    Lesson.find(params[:id])
    user = User.find_by(username: session[:username])

    option = Option.find_by(id: params[:answer].to_i)
    question_id = option.question.id

    session[:success] = nil
    session[:error] = nil

    question = option.question
    if option.value
      question.increment!(:correct_answers_count)
      user.progress.correct_answer(question_id)
      session[:success] = 'correct_answer'
    else
      question.increment!(:incorrect_answers_count)
      session[:error] = 'wrong_answer'
    end

    redirect "/learning/lesson/#{params[:id]}/play"
  end
end
