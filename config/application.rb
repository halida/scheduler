require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

load File.join(File.dirname(__FILE__), './initializers/settings.rb')

module Scheduler
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/lib)

    config.cache_store = :redis_store,
      "redis://#{ Settings.redis.host }:#{ Settings.redis.port }/#{ Settings.redis.cache_db }/cache",
      { expires_in: 1.day }
  end
end
