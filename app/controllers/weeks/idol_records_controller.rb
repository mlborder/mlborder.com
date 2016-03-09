class Weeks::IdolRecordsController < ApplicationController
  def index
    @weeks = Week.all

    @week = Week.find_by(id: params[:search_week_id].to_i) if params[:search_week_id]
    @week ||= Week.find_by_ymd(params[:week_id]) || Week.last
    redirect_to week_idol_records_path(week_id: @week.to_ymd) and return unless params[:week_id] == @week.to_ymd
    @idol_records = @week.idol_records
  end
end
