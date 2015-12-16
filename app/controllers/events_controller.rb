class EventsController < ApplicationController
  def index
    @events = Event.order(id: :asc)
  end

  def show
    @event = params[:id].present? ? Event.find(params[:id]) : Event.border_available.last
    return redirect_to events_path if @event.nil?
    @dataset = @event.border.dataset if @event.has_border?
    @recent_events = Event.send(@event.event_type.to_sym).border_available.order(started_at: :desc).limit(10)

    respond_to do |format|
      format.html
      format.json { render json: { name: @event.name, started_at: @event.started_at, ended_at: @event.ended_at } }
    end
  end
end
