class DramacdTheme::VoteProgress
  @@meta_columns = %w(time updated_at)

  def initialize(theme)
    raise ArgumentError unless theme.instance_of? DramacdTheme
    @theme = theme
    @series_name = theme.series_name
  end

  def recent_series_data
    @recent_series_data ||= InfluxDB::Rails.client.query("SELECT * FROM \"#{@series_name}\" ORDER BY time DESC LIMIT 1;").first['values'].first
  end

  def latest
    values = recent_series_data.select { |k, _| k.include? 'vote_' }.inject({}) do |h, (key, vote_cnt)|
      theme_id, role_id, idol_id = key.split('_')[1..3].map(&:to_i)

      h.deep_merge({
        theme_id => {
          role_id => {
            idol_id => vote_cnt.to_i
          }
        }
      })
    end

    { time: Time.parse(recent_series_data['time']).in_time_zone('Tokyo'), values: values }
  end

  def with_previous(target_time = Time.now, duration = 1.hour)
    target_time = @theme.end_time + 1.second if @theme.end_time < target_time
    str_time_to = target_time.to_i
    str_time_from = (target_time - duration).to_i
    ret = InfluxDB::Rails.client.query "SELECT * FROM \"#{@series_name}\" WHERE time <= #{str_time_to}s AND time >= #{str_time_from - 300}s"
    while ret.empty?
      target_time -= 1.hour
      str_time_to = target_time.to_i
      str_time_from = (target_time - duration).to_i
      ret = InfluxDB::Rails.client.query "SELECT * FROM \"#{@series_name}\" WHERE time <= #{str_time_to}s AND time >= #{str_time_from - 300}s"
    end
    values = ret.first['values'].reverse

    latest_time = Time.parse(values.first['time'])
    index = -1
    values.each_with_index do |data, i|
      next if (latest_time - Time.parse(data['time']) < duration)
      index = i
      break
    end

    [values.first, values[index]].map do |raw_data|
      values = raw_data.select { |k, _| k.include? 'vote_' }.inject({}) do |h, (key, vote_cnt)|
        theme_id, role_id, idol_id = key.split('_')[1..3].map(&:to_i)

        h.deep_merge({
          theme_id => {
            role_id => {
              idol_id => vote_cnt.to_i
            }
          }
        })
      end

      { time: Time.parse(raw_data['time']).in_time_zone('Tokyo'), values: values }
    end
  end

  def dataset
    ret = { 1 => [], 2 => [], 3 => [], 4 => [], 5 => [] }
    progress['values'].each do |data|
      time = Time.parse(data['time']).to_i
      (1..5).each do |role_id|
        val = data.select do |k, v|
          next unless k.include? 'vote_'
          k.match(/_\d+_(\d+)_/)[1].to_i == role_id
        end
        val = val.merge({ 'time' => time })
        ret[role_id] << val
      end
    end
    ret
  end

  def progress
    select_target = columns.map { |column| "MIN(#{column}) AS #{column}" }
    query = "SELECT #{select_target.join(',')} FROM \"#{@series_name}\" WHERE time >= #{@theme.start_time.to_i}s AND time <= #{@theme.end_time.to_i + 1}s GROUP BY time(1h) fill(previous);"
    InfluxDB::Rails.client.query(query).first
  end

  def columns
    raw_columns = recent_series_data.keys

    vote_columns = raw_columns.select { |k| k.include? "vote_#{@theme.id}_" }
    other_columns = raw_columns.select do |k|
      !(k.include?('vote_') || @@meta_columns.include?(k))
    end

    @columns = vote_columns.concat other_columns
  end
end
