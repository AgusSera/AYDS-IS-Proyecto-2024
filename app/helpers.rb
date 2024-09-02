helpers do
    def obtener_ranking_usuarios
        usuarios = User.includes(:progress).all.to_a  # Use includes to avoid N+1 query problem
        usuarios_with_progress = usuarios.select { |usuario| usuario.progress.present? }
      
        usuarios_with_progress.sort_by do |usuario|
          [-usuario.progress.last_completed_lesson, -usuario.progress.calculate_success_rate]
        end
    end
end
