class Event::Border
  @@meta_columns = %w(time updated_at)

  def initialize(event, series_name = nil)
    raise ArgumentError unless event.instance_of? Event
    @event = event
    @series_name = series_name || event.series_name
  end

  def dataset
    dataset = progress['values']
    dataset.map { |data| data['time'] = Time.parse(data['time']).to_i; data }
  end

  def latest
    borders = recent_series_data.select { |k, _| k.include? 'border_' }.inject({}) do |h, (rank, pt)|
      h.merge({ rank.match(/\d+/).to_s.to_i => pt.to_i })
    end

    { time: Time.parse(recent_series_data['time']), borders: borders }
  end

  private
  def progress
    return @progress if @progress.present?

    @progress = query_with_cache
    @progress
  end

  def query_with_cache
    return cached_dataset if cached_dataset

    select_target = columns.map { |column| "MIN(#{column}) AS #{column}" }
    span = (@event.imc_event? || @event.imce_event?) ? '5m' : '30m'

    query = "SELECT #{select_target.join(',')} FROM \"#{@series_name}\" WHERE time >= #{@event.started_at.to_i}s AND time <= #{@event.ended_at.to_i + 1}s GROUP BY time(#{span}) fill(previous);"
    InfluxDB::Rails.client.query(query).first
  end

  def cached_dataset
    unless @cached_dataset
      s3_object = s3_client.get_object(bucket: 'mlborder', key: "events/#{@series_name}.json")
      @cached_dataset = JSON.load(s3_object.body.read)
    end
    @cached_dataset
  rescue Aws::S3::Errors::NoSuchKey
  end

  def recent_series_data
    if cached_dataset
      cached_dataset['values'].last
    else
      return @recent_series_data if @recent_series_data
      res = InfluxDB::Rails.client.query "SELECT * FROM \"#{@series_name}\" ORDER BY time DESC LIMIT 1;"
      @recent_series_data = res.first['values'].first
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

  def s3_client
    @s3 ||= Aws::S3::Client.new
  end
end
