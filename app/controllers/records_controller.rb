class RecordsController < ApplicationController
  def index
    @events = Event.where(records_available: true).order(id: :desc)

    if params[:player_id].present?
      @player = Player.find(params[:player_id])
      @records = @player.records
    elsif params[:event_id].present?
      @event = Event.find_by(id: params[:event_id])
      @idol = Idol.find_by(id: params[:idol_id].to_i)
      @page_num = [1, params[:page].to_i].max
      @records = @event.records(@page_num, @idol.try(:id))
    end
  end
end
