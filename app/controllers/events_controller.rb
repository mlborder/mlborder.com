class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])

    if @event.has_border?
      progress = @event.border.progress
      @dataset = progress.values.first
    end
  end
end
