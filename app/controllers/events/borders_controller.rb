class Events::BordersController < ApplicationController
  include AuthActions
  before_action :authenticate_admin!, only: %i(update)
  before_action :set_event

  def index
    if @event.has_border?
      if params['team_rank']
        render json: @event.border(Event::ULA_FINAL_TEAM_SERIES_NAME).dataset.to_json
      else
        render json: @event.border.dataset.to_json
      end
    else
      render json: nil, status: :not_found
    end
  end

  def recent
    if @event.has_border?
      if @event.update_final_border_info!
        render json: { message: 'ボーダー情報を更新しました' }, status: :created
      else
        raise RuntimeError
      end
    else
      render json: nil, status: :not_found
    end
  rescue => e
    render json: { message: 'ボーダー情報の更新に失敗しました' }, status: :internal_server_error
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end
end
