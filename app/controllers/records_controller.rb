class RecordsController < ApplicationController
  def index
    @events = Event.where(records_available: true).includes(:prizes).order(id: :desc)

    if params[:player_id].present?
      @player = Player.find(params[:player_id])
      @records = @player.records
    elsif params[:event_id].present?
      redirect_to event_records_path(params[:event_id], idol_id: params[:idol_id], page: params[:page]), status: :moved_permanently
    end
  end
end
