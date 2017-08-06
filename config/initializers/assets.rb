Rails.application.config.assets.tap do |assets|
  assets.version = '1.0'
  assets.manifest = File.join(Rails.root, "public", "assets", "manifest.json")
  assets.initialize_on_precompile = false
end

if Rails.application.config.respond_to?(:browserify_rails)
  Rails.application.config.browserify_rails.tap do |browserify|
    browserify.paths << '--paths ./app/assets/javascripts/'
    browserify.commandline_options = [
      '--fast',
      '-t [ babelify --presets [ react es2015 ] ]'
    ]
    browserify.source_map_environments << 'development'
    browserify.node_env = 'production'
  end
end
