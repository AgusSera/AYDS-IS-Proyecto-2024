helpers do
    def start_scheduler
        scheduler = Rufus::Scheduler.new
        
        scheduler.every '5s' do
          users = User.where('remaining_life_points <= 0 AND updated_at <= ?', 1.minute.ago)
          users.each do |user|
            user.update(remaining_life_points: [user.remaining_life_points + 3, 0].max) # El usuario recupera las vidas.
          end
        end
    end

    def obtener_ranking_usuarios
        usuarios = User.includes(:progress).all.to_a  # Use includes to avoid N+1 query problem
        usuarios_with_progress = usuarios.select { |usuario| usuario.progress.present? }
      
        usuarios_with_progress.sort_by do |usuario|
          [-usuario.progress.last_completed_lesson, -usuario.progress.calculate_success_rate]
        end
    end

    def handle_correct_answer(progress, question)

      question_id = question.id
      correct_questions = progress.correct_answered_questions || []
      correct_questions << question_id unless correct_questions.include?(question_id)
      progress.correct_answered_questions = correct_questions
  
      progress.increase_number_of_correct_answers
      progress.save
  
      session[:success] = 'correct_answer'
      redirect "/lesson/#{params[:id]}/play"
    end
  
    def handle_incorrect_answer(user, progress)
      progress.increase_number_of_incorrect_answers
      user.subtract_life_point
      if user.remaining_life_points <= 0
        session[:error] = 'no_lives_remaining'
      else
        session[:error] = 'wrong_answer'
      end
      redirect "/lesson/#{params[:id]}/play"
    end
  
  
    def authenticate_user(username, password)
      User.find_by(username: username, password: password)
    end
  
    def update_password(user, new_password, confirm_password)
      if new_password == confirm_password
        user.update(password: new_password)
        if user.save
          { success_message: "Password changed successfully!" }
        else
          { error_message: "Failed to update password." }
        end
      else
        { error_message: "New password and confirm password do not match." }
      end
    end
  
    def update_email(user, new_email)
      user.update(email: new_email)
      if user.save
        { success_message: "Email changed successfully!" }
      else
        { error_message: "Failed to update email." }
      end
    end

end
