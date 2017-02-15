class RecordsController < ApplicationController
  def index
    @events = Event.where(records_available: true).includes(:prizes).order(id: :desc)

    if params[:player_id].present?
      redirect_to player_records_path(params[:player_id])
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
      player_records_path(params[:target_id])
    else
      records_path
    end
  end

  def idol_params
    { idol_id: params[:idol_id].presence }.compact
  end
end
