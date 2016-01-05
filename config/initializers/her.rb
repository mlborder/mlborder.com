# config/initializers/her.rb
Her::API.setup url: (ENV['HER_DATA_API_SERVER'] || 'http://localhost:8080') do |c|
  # Request
  c.use Faraday::Request::UrlEncoded

  # Response
  c.use Her::Middleware::DefaultParseJSON

  # Adapter
  c.use Faraday::Adapter::NetHttp
end
