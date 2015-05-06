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

  def latest
    @event = Event.border_available.last
    @dataset = @event.border.progress.values.first

    render action: 'show'
  end
end
