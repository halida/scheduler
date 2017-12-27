if Settings[:airbrake]
  c = Settings.airbrake
  Airbrake.configure do |config|
    config.project_id = c.project_id
    config.project_key = c.project_key
    config.host    = c.host

    config.environment = Rails.env
    # for testing development raise error
    # config.ignore_environments = %w(test)
  end
end
