class IdolsController < ApplicationController
  def index
    @idols = Idol.all
  end

  def show
    @idol = Idol.find(idol_params[:id])
    @events = Event.includes(:prizes).includes(:final_borders).order(id: :desc).where(id: @idol.event_prizes.pluck(:event_id))
  end

  private
  def idol_params
    params.permit(:id)
  end
end
