class Settings < Settingslogic
  source File.join(File.dirname(__FILE__), "../application.yml")
  namespace ENV['RAILS_ENV'] || 'development'
end
