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

  def search
    redirect_to redirect_path
  end

  private

  def redirect_path
    return records_path if params[:target_id].blank?

    case params[:target_type]
    when 'weekly_idol'
      week_idol_records_path(params[:target_id])
    when 'weekly_player'
      week_player_records_path(params[:target_id], idol_params)
    when 'event'
      event_records_path(params[:target_id], idol_id: idol_params)
    when 'player'
      records_path( { player_id: params[:target_id].presence }.compact )
    else
      records_path
    end
  end

  def idol_params
    { idol_id: params[:idol_id].presence }.compact
  end
end
