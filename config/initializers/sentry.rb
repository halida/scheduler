if Settings[:sentry]
  Raven.configure do |config|
    setry_config = Settings.sentry
    config.dsn = setry_config.dsn
    config.current_environment = setry_config.environment
  end
end
