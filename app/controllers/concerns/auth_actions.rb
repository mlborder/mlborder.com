module AuthActions
  def authenticate_admin!
    (redirect_to root_path and return) if current_user.nil?
    (redirect_to root_path and return) unless current_user.role_admin?
  end
end
