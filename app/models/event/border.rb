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

  def border_with_velocity(target_time = Time.now, duration = 1.hour)
    target_time = @event.ended_at + 1.second if @event.ended?
    str_time_to = target_time.to_i
    str_time_from = (target_time - duration).to_i
    ret = InfluxDB::Rails.client.query "SELECT * FROM \"#{@series_name}\" WHERE time <= #{str_time_to}s AND time >= #{str_time_from - 300}s"
    values = ret.first['values'].reverse

    index = -1
    latest_time = Time.parse(values.first['time'])
    values.each_with_index do |data, i|
      if (latest_time.to_i - Time.parse(data['time']).to_i) >= duration
        index = i
        break
      end
    end

    [values.first, values[index]].map do |raw_data|
      raw_data.select { |k, _| k.include? 'border_' }.inject({}) do |h, (rank, pt)|
        h.merge({ rank.match(/\d+/).to_s.to_i => pt.to_i })
      end
    end
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
    span = (@event.imc_event? || @event.imce_event?) ? '5m' : '30m'

    query = "SELECT #{select_target.join(',')} FROM \"#{@series_name}\" WHERE time >= #{@event.started_at.to_i}s AND time <= #{@event.ended_at.to_i + 1}s GROUP BY time(#{span}) fill(previous);"
    @progress = InfluxDB::Rails.client.query(query).first
  end

  def dataset
    dataset = progress['values']
    dataset.map { |data| data['time'] = Time.parse(data['time']).to_i; data }
  end
end
