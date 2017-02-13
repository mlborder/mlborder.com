class Weeks::PlayerRecordsController < ApplicationController
  def index
    @weeks = Week.all
    @week = Week.find_by_ymd(params[:week_id]) || Week.last
    return redirect_to week_player_records_path(week_id: @week.to_ymd) unless params[:week_id] == @week.to_ymd

    @page_num = [1, params[:page].to_i].max
    @idol = Idol.find_by(id: params[:idol_id].to_i)
    @player_records = @week.player_records(@page_num, idol_id: @idol&.id)
  end

  def search
    redirect_to week_player_records_path(permit_params[:next_week_id], {idol_id: permit_params[:idol_id].presence}.compact)
  end

  private

  def permit_params
    params.permit(
      :next_week_id,
      :idol_id
    )
  end
end
