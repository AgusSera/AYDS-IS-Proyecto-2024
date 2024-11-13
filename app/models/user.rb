# frozen_string_literal: true

# User model
class User < ActiveRecord::Base
  # CF de la relacion 1 a 1 con Progress en la tabla Progress
  belongs_to :progress
  has_secure_password

  # Validaciones
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  # El usuario es administrador?
  def admin?
    is_a?(Admin)
  end

  def change_password(current_password, new_password, confirm_new_password)
    if authenticate(current_password) && new_password == confirm_new_password
      self.password = new_password
      save
    else
      false
    end
  end

  def change_email(new_email, current_password)
    if authenticate(current_password)
      self.email = new_email
      save
    else
      false
    end
  end
end
