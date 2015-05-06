InfluxDB::Rails.configure do |config|
  config.influxdb_database = ENV['BORDERBOT_INFLUXDB_DATABASE'] || "eventborders"
  config.influxdb_username = ENV['BORDERBOT_INFLUXDB_USERNAME'] || "atndk"
  config.influxdb_password = ENV['BORDERBOT_INFLUXDB_PASSWORD'] || "test"
  config.influxdb_hosts    = ENV['BORDERBOT_INFLUXDB_HOST'].nil? ? ["localhost"] : [ENV['BORDERBOT_INFLUXDB_HOST']]
  config.influxdb_port     = ENV['BORDERBOT_INFLUXDB_PORT'] || 8086

  config.logger = Logger.new(STDERR)
  config.logger.level = Logger::FATAL
  # config.series_name_for_controller_runtimes = "rails.controller"
  # config.series_name_for_view_runtimes       = "rails.view"
  # config.series_name_for_db_runtimes         = "rails.db"
end
