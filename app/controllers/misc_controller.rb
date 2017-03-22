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

    event_csv = EventCSV.new(
      @event,
      summarized: params[:summarized].present?,
      detail: params[:detail].present?,
      key: params[:target],
      sjis: params[:encoding] == 'sjis'
    )
    @updated_at = event_csv.updated_at

    respond_to do |format|
      format.html do
        @dropdown_options = event_csv.options
        @selected_option = event_csv.selected_option
        @idol_options = Rubimas.all.select { |i| i.id > 13 }.map { |idol| [idol.name.to_s, idol.id] }
      end
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
    def initialize(event_abbr, key:, summarized: false, detail: false, sjis: false)
      @event = event_abbr
      @summarized = summarized
      @detail = detail
      @sjis = sjis
      @key = key
    end

    def build
      if @summarized
        if @detail
          CSV.generate(write_headers: true, force_quotes: true) do |csv|
            CSV.new(s3_body).each.with_index do |row, index|
              csv << row if index.zero?
              next if index < 200
              next if index > 320
              csv << row
            end
          end
        else
          CSV.generate(write_headers: true, force_quotes: true) do |csv|
            CSV.new(s3_body).each.with_index do |row, index|
              csv << row if index.zero?
              csv << row if index % 10 == 1
            end
          end
        end
      elsif @sjis
        CSV.generate(write_headers: true, force_quotes: true, encoding: 'Shift_JIS') do |csv|
          CSV.new(s3_body, encoding: 'UTF-8').each { |row| csv << row }
        end
      else
        s3_body.read
      end
    end

    def filename
      "#{@event}-#{updated_at.strftime('%Y%m%d-%H%M')}.csv"
    end

    def encoding
      @sjis ? 'shift_jis' : 'utf-8'
    end

    def updated_at
      Time.strptime("#{selected_option} +0900", '%Y%m%d-%H%M')
    end

    def options
      s3_keys.map do |key|
        filebase = File.basename(key, '.csv')
        time = Time.strptime("#{filebase} +0900", '%Y%m%d-%H%M')
        [ time.strftime('%m月%d日%H:%M頃'), filebase ]
      end
    end

    def selected_option
      File.basename(s3_key, '.csv')
    end

    private
    def s3_body
      cache_path = Rails.root.join("tmp/#{s3_key}")
      if File.exist?(cache_path)
        open(cache_path)
      else
        res = s3_client.get_object(bucket: 'mlborder', key: s3_key)
        FileUtils.mkdir_p(File.dirname(cache_path))
        read_body = res.body.read
        open(cache_path, 'w') { |f| f.write read_body }
        read_body
      end
    end

    def s3_key
      @s3_key ||= (provided_s3_key.presence || s3_keys.last)
    end

    def provided_s3_key
      "runners/#{@event}/#{@key}.csv" if @key.present?
    end

    def s3_keys
      return @s3_keys if @s3_keys
      continuation_token = nil
      @s3_keys = []
      begin
        params = { bucket: 'mlborder', prefix: "runners/#{@event}/20", continuation_token: continuation_token }.compact
        s3_client.list_objects_v2(**params).tap do |response|
          @s3_keys += response.contents.map(&:key)
          continuation_token = response.next_continuation_token
        end
      end while continuation_token.present?
      @s3_keys
    end

    def s3_client
      @s3 ||= Aws::S3::Client.new
    end
  end
end
