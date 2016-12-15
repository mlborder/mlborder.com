# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

if Rails.application.config.respond_to?(:browserify_rails)
  Rails.application.config.browserify_rails.paths << '--paths ./app/assets/javascripts/'
  Rails.application.config.browserify_rails.commandline_options = [
    '--fast',
    '-t coffeeify --extension=.coffee',
    '-t babelify --presets [ es2015 ]'
  ]
  Rails.application.config.browserify_rails.source_map_environments << 'development'
  Rails.application.config.browserify_rails.node_env = 'production'
end
