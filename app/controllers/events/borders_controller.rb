class Events::BordersController < ApplicationController
  before_action :set_event

  def index
    if @event.has_border?
      render json: @event.border.dataset.to_json
    else
      render json: nil, status: :not_found
    end
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end
end
