class Events::BordersController < ApplicationController
  before_action :set_event

  def index
    if @event.has_border?
      if params['team_rank']
        render json: @event.border(Event::ULA_FINAL_TEAM_SERIES_NAME).dataset.to_json
      else
        render json: @event.border.dataset.to_json
      end
    else
      render json: nil, status: :not_found
    end
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end
end
