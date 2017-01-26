class Users::AlarmsController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  def index
    @alarms_by_events = @user.event_grouped_alarms
    @alarm = Alarm.new
    @event = Event.border_available.last
    if @event.in_session?
      @latest_data = @event.border.latest
    end
  end

  def create
    alarm = @user.alarms.build(alarm_params).tap { |a| a.target = :target_border; a.status = :status_valid }
    alarm.save

    redirect_to user_alarms_path(@user)
  end

  private
  def authenticate_user!
    (redirect_to alarm_path and return) unless current_user
    return true if current_user.role_admin?
    (redirect_to user_alarms_path(current_user) and return) unless is_current_user?(@user)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def alarm_params
    params.require(:alarm).permit(
      :event_id,
      :rank,
      :value
    )
  end
end
