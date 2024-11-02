# frozen_string_literal: true

# Helpers module provides utility methods for the application.
module Helpers
  def current_user
    @current_user ||= User.find_by(username: session[:username])
  end

  def admin?
    current_user&.admin?
  end

  def authorize_admin!
    redirect '/dashboard' unless admin?
  end
end
