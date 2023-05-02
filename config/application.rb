require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

load File.join(File.dirname(__FILE__), './initializers/settings.rb')

module Scheduler
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.autoload_paths += %W(#{config.root}/lib)
    config.eager_load_paths += %W(#{config.root}/lib)

    config.cache_store = :redis_cache_store, \
    {url: "redis://#{ Settings.redis.host }:#{ Settings.redis.port }/#{ Settings.redis.cache_db }/cache", expires_in: 1.day }

    config.action_controller.asset_host = Settings.host
    config.action_mailer.default_url_options = { protocol: Settings.protocol, host: Settings.host }
  end
end
