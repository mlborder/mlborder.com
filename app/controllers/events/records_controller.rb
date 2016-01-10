class Events::RecordsController < ApplicationController
  before_action :set_event

  def index
    if @event.records_available?
      @idol = Idol.find_by(id: params[:idol_id].to_i)
      @page_num = [1, params[:page].to_i].max
      @records = @event.records(@page_num, @idol.try(:id))
    else
      redirect_to event_path(@event)
    end
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end
end
