class StaticPagesController < ApplicationController
  def home
    @latest_event = Event.last
  end

  def about
  end

  def alarm
    if current_user
      redirect_to user_alarms_path(current_user) and return
    end
  end
end
