class Players::RecordsController < ApplicationController
  def index
    @player = Player.find(params[:player_id]) || (raise ActiveRecord::RecordNotFound)
    @events = Event.all.includes(:prizes)
    @records = @player.records
  end
end
