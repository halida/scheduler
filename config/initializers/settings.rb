class Settings < Settingslogic
  path = File.dirname(__FILE__)

  filename = File.join(path, "../../storage/application.yml")
  unless File.exist?(filename)
    dummy_filename = File.join(path, "../application.dummy.yml")
    puts "cannot find #{filename}, use #{dummy_filename}"
    filename = dummy_filename
  end
  source filename

  namespace ENV['RAILS_ENV'] || 'development'
end

config = Rails.application.config
config.hosts << Settings.host
config.action_mailer.default_url_options = \
{ host: Settings.host, protocol: Settings.protocol }

if smtp_config = Settings[:smtp_settings]
  config.action_mailer.smtp_settings = smtp_config.symbolize_keys
  # can disable email delivery in config, like:
  #   send_email: false
  if smtp_config[:send_email]
    config.action_mailer.perform_deliveries = smtp_config[:send_email]
  end
end


if Settings[:sentry] and setry_config = Settings.sentry
  Raven.configure do |config|
    config.dsn = setry_config.dsn
    config.current_environment = setry_config.environment
  end
end
