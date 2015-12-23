class StaticPagesController < ApplicationController
  def home
    redirect_to event_path(Event.border_available.last)
  end

  def about
  end
end
