Airbrake.configure do |config|
  if Settings[:airbrake]
    c = Settings.airbrake
    config.project_id = c.project_id
    config.project_key = c.project_key
    config.host    = c.host
  end

  config.environment = Rails.env
  # for testing development raise error
  # config.ignore_environments = %w(test)
  config.ignore_environments = %w(development test)
end
