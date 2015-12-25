class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_action :effect_time_zone

  def time_zone
    'Tokyo'
  end

  def effect_time_zone(&block)
    Time.use_zone(time_zone, &block) if block.present?
  end

  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
