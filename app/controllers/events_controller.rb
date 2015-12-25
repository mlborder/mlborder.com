class EventsController < ApplicationController
  def index
    @events = Event.includes(:final_borders).order(id: :desc).page(params[:page])
  end

  def show
    @event = params[:id].present? ? Event.find(params[:id]) : Event.border_available.last
    return redirect_to events_path if @event.nil?
    @latest_data = @event.border.latest if @event.has_border?
    @dataset = @event.border.dataset if @event.has_border?
    @recent_events = Event.includes(:final_borders).send(@event.event_type.to_sym).border_available.order(started_at: :desc).limit(10)

    respond_to do |format|
      format.html
      format.json { render json: { name: @event.name, started_at: @event.started_at, ended_at: @event.ended_at } }
    end
  end
end
