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

Rails.application.config.hosts << Settings.host


if Settings[:sentry] and setry_config = Settings.sentry
  Raven.configure do |config|
    config.dsn = setry_config.dsn
    config.current_environment = setry_config.environment
  end
end
