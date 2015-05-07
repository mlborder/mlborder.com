class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = params[:id].present? ? Event.find(params[:id]) : Event.border_available.last
    @dataset = @event.border.dataset if @event.has_border?
  end
end
