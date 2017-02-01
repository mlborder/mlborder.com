class Users::AlarmsController < ApplicationController
  before_action :set_user
  def index
    (redirect_to alarm_path and return) unless current_user
    unless @user.role_admin?
      (redirect_to user_alarms_path(@user) and return) if (@user.id != current_user.id)
    end

    @alarms_by_events = @user.event_grouped_alarms

    @alarm = Alarm.new
    @event = Event.border_available.last
    if @event.in_session?
      @latest_data = @event.border.latest
    end
  end

  def create
    (redirect_to alarm_path and return) unless current_user
    (redirect_to user_alarms_path(@user) and return) if @user.id != current_user.id

    alarm = @user.alarms.build(alarm_params).tap { |a| a.target = :target_border; a.status = :status_valid }
    alarm.save

    redirect_to user_alarms_path(@user)
  end

  private
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
