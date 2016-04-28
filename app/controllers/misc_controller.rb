require 'csv'

class MiscController < ApplicationController
  def bmd_runner
    @idol_colors = (14..50).inject({}) do |colors, idol_id|
      idol = 765.pro.find_by_id(idol_id)
      colors.merge({
        idol.name.shorten => idol.color
      })
    end

    csv_filepath = Dir.glob(Rails.root.join('public', 'bmd_runners', '*').to_s).sort.last
    @updated_at = Time.strptime("2016-#{csv_filepath.split('/').last.split('_').second} +0900", '%Y-%m-%d-%H-%M-%S')

    respond_to do |format|
      format.html
      format.csv do
        filename = "bmd-#{@updated_at.strftime('%Y-%m-%d-%H-%M')}.csv"
        if params[:summarized].present?
          if params[:detail].present?
            csv_data = CSV.generate(write_headers: true, force_quotes: true) do |csv|
              CSV.foreach(csv_filepath).with_index do |row, index|
                csv << row if index.zero?
                next if index < 200
                next if index > 320
                csv << row
              end
            end
            send_data csv_data, type: 'text/csv; charset=utf-8', filename: filename
          else
            csv_data = CSV.generate(write_headers: true, force_quotes: true) do |csv|
              CSV.foreach(csv_filepath).with_index do |row, index|
                csv << row if index.zero?
                csv << row if index % 10 == 1
              end
            end
            send_data csv_data, type: 'text/csv; charset=utf-8', filename: filename
          end
        elsif params[:encoding] == 'sjis'
          csv_data = CSV.generate(write_headers: true, force_quotes: true) do |csv|
            CSV.foreach(csv_filepath, encoding: 'UTF-8:Shift_JIS') { |row| csv << row }
          end
          send_data csv_data, filename: filename, type: 'text/csv; charset=shift_jis'
        else
          send_file csv_filepath, filename: filename
        end
      end
    end
  end
end
