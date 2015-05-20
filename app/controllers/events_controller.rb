class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = params[:id].present? ? Event.find(params[:id]) : Event.border_available.last
    @dataset = @event.border.dataset if @event.has_border?

    # for internal API
    respond_to do |format|
      format.html
      format.json { render json: { name: @event.name, started_at: @event.started_at, ended_at: @event.ended_at } }
    end
  end
end
