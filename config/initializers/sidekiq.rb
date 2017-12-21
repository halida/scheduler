require "sidekiq"

sidekiq_config = Settings.sidekiq

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{ sidekiq_config.host }:#{ sidekiq_config.port }/#{ sidekiq_config.db }",
    namespace: sidekiq_config.namespace,
  }

  # if defined? Airbrake
  #   Airbrake.configure do |config|
  #     # Airbrake should not ignore any exceptions in sidekiq
  #     config.ignore_only = []
  #   end
  # end

  config.server_middleware do |chain|
    # Don't need retry, just fail it to Dead queue
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 0
    # chain.add Sidekiq::Status::ServerMiddleware
  end
  
  # config.client_middleware do |chain|
  #   # accepts :expiration (optional)
  #   chain.add Sidekiq::Status::ClientMiddleware
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
