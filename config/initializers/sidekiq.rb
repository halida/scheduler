require "sidekiq"

# for whenever sidekiq-client-cli
unless defined?(Settings)
  require 'settingslogic'
  load File.join(File.dirname(__FILE__), './settings.rb')
end
sidekiq_config = Settings.sidekiq

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{ sidekiq_config.host }:#{ sidekiq_config.port }/#{ sidekiq_config.db }",
    namespace: sidekiq_config.namespace,
  }

  Sidekiq.options[:max_retries] = 0

  # if defined? Airbrake
  #   Airbrake.configure do |config|
  #     # Airbrake should not ignore any exceptions in sidekiq
  #     config.ignore_only = []
  #   end
  # end

end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{ sidekiq_config.host }:#{ sidekiq_config.port }/#{ sidekiq_config.db }",
    namespace: sidekiq_config.namespace,
  }
  # config.client_middleware do |chain|
  #   # accepts :expiration (optional)
  #   chain.add Sidekiq::Status::ClientMiddleware
  # end
end
