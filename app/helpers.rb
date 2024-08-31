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
end
