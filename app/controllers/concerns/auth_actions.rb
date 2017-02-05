module AuthActions
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def authenticate_admin!
    (redirect_to root_path and return) if current_user.nil?
    (redirect_to root_path and return) unless current_user.role_admin?
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def is_current_user?(user)
    user.id == current_user.id
  end
end
