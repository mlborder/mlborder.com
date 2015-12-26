class Event::Border
  @@meta_columns = %w(time updated_at)

  def initialize(event)
    raise ArgumentError unless event.instance_of? Event
    @event = event
    @series_name = event.series_name
  end

  def recent_series_data
    return @recent_series_data if @recent_series_data
    res = InfluxDB::Rails.client.query "SELECT * FROM \"#{@series_name}\" ORDER BY time DESC LIMIT 1;"
    @recent_series_data = res.first['values'].first
  end

  def latest
    borders = recent_series_data.select { |k, _| k.include? 'border_' }.inject({}) do |h, (rank, pt)|
      h.merge({ rank.match(/\d+/).to_s.to_i => pt.to_i })
    end

    { time: Time.parse(recent_series_data['time']), borders: borders }
  end

  def columns
    return @columns if @columns.present?

    target_series_data = recent_series_data
    raw_columns = target_series_data.keys

    border_columns = raw_columns.select { |k| k.include?('border_') }.sort { |a, b| a.match(/(\d+)/).to_s.to_i <=> b.match(/(\d+)/).to_s.to_i }
    other_columns = raw_columns.select do |k|
      !(k.include?('border_') || @@meta_columns.include?(k))
    end

    @columns = border_columns.concat other_columns
  end

  def progress
    return @progress if @progress.present?

    select_target = columns.map { |column| "MIN(#{column}) AS #{column}" }
    span =  @event.imc_event? ? '5m' : '30m'

    query = "SELECT #{select_target.join(',')} FROM \"#{@series_name}\" WHERE time >= #{@event.started_at.to_i}s AND time <= #{@event.ended_at.to_i + 1}s GROUP BY time(#{span}) fill(previous);"
    @progress = InfluxDB::Rails.client.query(query).first
  end

  def dataset
    dataset = progress['values']
    dataset.map { |data| data['time'] = Time.parse(data['time']).to_i; data }
  end
end
