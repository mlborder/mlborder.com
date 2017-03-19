require 'csv'

class MiscController < ApplicationController
  def runners
    @event = abbr_events.include?(params[:event]) ? params[:event] : abbr_events.last

    @idol_colors = (14..50).inject({}) do |colors, idol_id|
      idol = 765.pro.find_by_id(idol_id)
      colors.merge({
        idol.name.shorten => idol.color
      })
    end

    event_csv = EventCSV.new(@event, summarized: params[:summarized].present?, detail: params[:detail].present?, sjis: params[:encoding] == 'sjis')
    @updated_at = event_csv.updated_at

    respond_to do |format|
      format.html
      format.csv do
        send_data event_csv.build, filename: event_csv.filename, type: "text/csv; charset=#{event_csv.encoding}"
      end
    end
  end

  private

  def abbr_events
    %w(bmd tys)
  end

  class EventCSV
    def initialize(event_abbr, summarized: false, detail: false, sjis: false)
      @event = event_abbr
      @summarized = summarized
      @detail = detail
      @sjis = sjis
    end

    def build
      if @summarized
        if @detail
          CSV.generate(write_headers: true, force_quotes: true) do |csv|
            CSV.new(s3_object.body).each.with_index do |row, index|
              csv << row if index.zero?
              next if index < 200
              next if index > 320
              csv << row
            end
          end
        else
          CSV.generate(write_headers: true, force_quotes: true) do |csv|
            CSV.new(s3_object.body).each.with_index do |row, index|
              csv << row if index.zero?
              csv << row if index % 10 == 1
            end
          end
        end
      elsif @sjis
        CSV.generate(write_headers: true, force_quotes: true, encoding: 'Shift_JIS') do |csv|
          CSV.new(s3_object.body, encoding: 'UTF-8').each { |row| csv << row }
        end
      else
        s3_object.read
      end
    end

    def filename
      "#{@event}-#{updated_at.strftime('%Y%m%d-%H%M')}.csv"
    end

    def encoding
      @sjis ? 'shift_jis' : 'utf-8'
    end

    def updated_at
      Time.strptime("#{s3_key.split('/').last.sub('.csv', '')} +0900", '%Y%m%d-%H%M')
    end

    private
    def s3_object
      s3_client.get_object(bucket: 'mlborder', key: s3_key)
    end

    def s3_key
      @s3_key ||= s3_keys.last
    end

    def s3_keys
      continuation_token = nil
      s3_keys = []
      begin
        params = { bucket: 'mlborder', prefix: "runners/#{@event}/", continuation_token: continuation_token }.compact
        s3_client.list_objects_v2(**params).tap do |response|
          s3_keys += response.contents.map(&:key)
          continuation_token = response.is_truncated ? nil : response.continuation_token
        end
      end while continuation_token.present?
      s3_keys
    end

    def s3_client
      @s3 ||= Aws::S3::Client.new
    end
  end
end
