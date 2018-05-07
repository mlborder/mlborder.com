class Events::RecordsController < ApplicationController
  before_action :set_event

  def index
    if request.xhr?
      if @event.records_available?
        @idol = Rubimas.find(params[:idol_id].to_i)
        @page_num = [1, params[:page].to_i].max
        @records = @event.records(@page_num, @idol.try(:id))

        render json: @records.map(&:attributes)
      else
        render json: nil, status: :not_found
      end
    else
      return redirect_to event_records_path(@event) if @event.id != params[:event_id].to_i
      @events = Event.records_available.order(id: :desc).select(:id, :name)
      if @event.records_available?
        @idol = Rubimas.find(params[:idol_id].to_i)
        @page_num = [1, params[:page].to_i].max
        @records = @event.records(@page_num, @idol.try(:id))

        respond_to do |format|
          format.html
          format.json { render json: @records.map(&:attributes) }
        end
      else
        redirect_to event_path(@event)
      end
    end
  end

  private
  def set_event
    @event = Event.find_by(id: params[:event_id]) || Event.records_available.last
  end
end
