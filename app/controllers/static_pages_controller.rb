class StaticPagesController < ApplicationController
  def home
    redirect_to event_path(Event.border_available.last)
  end

  def about
  end

  def enjoy_harmony
    event = Event.at('2015-05-29 17:00:00 +0900')
    return redirect_to events_path unless event

    redirect_to event
  end
end
