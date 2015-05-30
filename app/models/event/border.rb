class Event::Border
  @@meta_columns = %w(time sequence_number updated_at)

  def initialize(event)
    raise ArgumentError unless event.instance_of? Event
    @event = event
    @series_name = event.series_name
  end

  def columns
    return @columns if @columns.present?

    res = InfluxDB::Rails.client.query "SELECT * FROM \"#{@series_name}\" LIMIT 1;"
    series_datas = res.values
    target_series_data = series_datas.first
    raw_columns = target_series_data.first.keys

    border_columns = raw_columns.select { |c| c.include? 'border_' }.sort { |a, b| a.match(/(\d+)/).to_s.to_i <=> b.match(/(\d+)/).to_s.to_i }
    other_columns = raw_columns.select do |column|
      !(column.include?('border_') || @@meta_columns.include?(column))
    end

    @columns = border_columns.concat other_columns
  end

  def progress
    return @progress if @progress.present?

    select_target = columns.map { |column| "MIN(#{column}) AS #{column}" }
    @progress = InfluxDB::Rails.client.query "SELECT #{select_target.join(',')} FROM \"#{@series_name}\" GROUP BY time(30m) ORDER ASC;"
  end

  def dataset
    dataset = progress.values.first
    dataset.map { |value| Hash[ value.map { |k, v| [k, v > 1_000_000_000_000_000_000_000_000 ? 0 : v] } ] }
  end
end
