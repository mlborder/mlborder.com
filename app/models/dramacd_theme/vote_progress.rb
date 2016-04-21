class DramacdTheme::VoteProgress
  def initialize(theme)
    raise ArgumentError unless theme.instance_of? DramacdTheme
    @theme = theme
    @series_name = theme.series_name
  end

  def recent_series_data
    res = InfluxDB::Rails.client.query "SELECT * FROM \"#{@series_name}\" ORDER BY time DESC LIMIT 1;"
    @recent_series_data = res.first['values'].first
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
end
