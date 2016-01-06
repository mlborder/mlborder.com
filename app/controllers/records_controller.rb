class RecordsController < ApplicationController
  def index
    @events = Event.where(records_available: true).order(id: :desc)

    if params[:player_id].present?
      @player = Player.find(params[:player_id])
      @records = @player.records
    elsif params[:event_id].present?
      @event = Event.find(params[:event_id])
      @records = @event.records
    end
  end
end
