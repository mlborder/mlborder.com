class Event::Border
  def initialize(event)
    raise ArgumentError unless event.instance_of? Event
    @event = event
    @series_name = event.series_name
  end

  def rank_columns
    return @rank_columns if @rank_columns.present?

    res = InfluxDB::Rails.client.query "SELECT * FROM \"#{@series_name}\" LIMIT 1;"
    series_datas = res.values
    target_series_data = series_datas.first
    raw_columns = target_series_data.first.keys
    @rank_columns = raw_columns.select { |c| c.include? 'border_' }.sort { |a, b| a.match(/(\d+)/).to_s.to_i <=> b.match(/(\d+)/).to_s.to_i }
  end

  def progress
    select_target = []
    rank_columns.each do |column|
      select_target << "MIN(#{column}) AS #{column}"
    end

    InfluxDB::Rails.client.query "SELECT #{select_target.join(',')} FROM \"#{@series_name}\" GROUP BY time(30m) ORDER ASC;"
  end
end