# lib/silent_logger.rb

#
# SilentLogger can be used to keep requests out of log file
# It is best used for ping requests from uptime services like
# NewRelic, Uptime Robot, etc.
#
# Source: http://dennisreimann.de/blog/silencing-the-rails-log-on-a-per-action-basis/
#
# Include logger in your config/application.rb after require 'rails/all'
# require File.dirname(__FILE__) + '/../lib/silent_logger.rb'
#
# In application.rb or environments/production.rb swap Rails logger:
# config.middleware.swap Rails::Rack::Logger, SilentLogger, silenced: ['/newrelic-ping']
#
class SilentLogger < Rails::Rack::Logger

  def initialize(app, taggers = nil)
    @app = app
    @taggers = taggers

    if @taggers.keys.include? :silence
      @silenced_paths = @taggers[:silence]
      @taggers.delete(:silence)
    end

    super
  end

  def call(env)
    if (env['X-SILENCE-LOGGER'] ||
        @silenced_paths.include?(env['PATH_INFO']) ||
        @silenced_paths.any?{ |path|
          path.is_a?(Regexp) && path.match(env['PATH_INFO'])
        } ||
        # ignore zabbix checker
        (env['PATH_INFO'] == '/' and env['REQUEST_METHOD'] == 'HEAD')
       )
      Rails.logger.silence do
        @app.call(env)
      end
    else
      super
    end
  end

end
