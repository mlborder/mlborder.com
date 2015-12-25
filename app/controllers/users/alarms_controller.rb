class Users::AlarmsController < ApplicationController
  before_action :set_user
  def index
    (redirect_to watch_path and return) unless current_user
    (redirect_to user_alarms_path(@user) and return) if @user.id != current_user.id

    @alarms = @user.alarms
    @alarm = Alarm.new
    @event = Event.border_available.last
    if @event.in_session?
      @latest_data = @event.border.latest
    end
  end

  def create
    (redirect_to watch_path and return) unless current_user
    (redirect_to user_alarms_path(@user) and return) if @user.id != current_user.id

    alarm = @user.alarms.build(alarm_params).tap { |a| a.target = :target_border }
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
