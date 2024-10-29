# frozen_string_literal: true

helpers do
  def current_user
    @current_user ||= User.find_by(username: session[:username])
  end

  def admin?
    current_user&.admin?
  end

  def authorize_admin!
    redirect '/dashboard' unless admin?
  end

  def obtener_ranking_usuarios
    usuarios = User.includes(:progress).all.to_a # Use includes to avoid N+1 query problem
    usuarios_with_progress = usuarios.select { |usuario| usuario.progress.present? }

    usuarios_with_progress.sort_by do |usuario|
      [-usuario.progress.points, -usuario.progress.streak]
    end
  end
end
