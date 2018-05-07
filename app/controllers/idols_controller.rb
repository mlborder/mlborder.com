class IdolsController < ApplicationController
  def index
    @idols = Rubimas.all
  end

  def show
    @idol = Rubimas.find_by_id(idol_params[:id].to_i)
    @events = Event::Prize.includes(:event).where(idol_id: @idol.id).map(&:event)
  end

  private
  def idol_params
    params.permit(:id)
  end
end
