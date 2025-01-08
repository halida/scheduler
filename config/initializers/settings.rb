config = Rails.application.config
config.hosts << ENV["HOST"]
config.action_mailer.default_url_options = \
{ host: ENV["HOST"], protocol: ENV["PROTOCOL"] }

if ENV["SMTP"] == 'true'
  config.action_mailer.smtp_settings = {
    address: ENV["SMTP_SETTINGS_ADDRESS"],
    port: ENV["SMTP_SETTINGS_PORT"],
    authentication: ENV["SMTP_SETTINGS_AUTHENTICATION"],
    user_name: ENV["SMTP_SETTINGS_USER_NAME"],
    password: ENV["SMTP_SETTINGS_PASSWORD"],
    enable_starttls_auto: true,
  }
  # can disable email delivery in config, like:
  #   send_email: false
  if ENV["SMTP_SEND_EMAIL"] == "false"
    config.action_mailer.perform_deliveries = false
  end
end


if dsn = ENV["SENTRY_DSN"]
  Sentry.init do |config|
    config.dsn = dsn
    config.environment = ENV["SENTRY_ENV"]
  end
end
