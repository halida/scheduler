class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_sentry_context

  protected

  def check_during(default)
    default.map!{|v| v.in_time_zone(current_user.timezone)}

    tz_string = current_user.timezone.presence || Scheduler::Lib::TIMEZONES.first.to_s
    tz = ActiveSupport::TimeZone.new(tz_string)

    @begin_date = (params[:begin_date].present? and
                   (tz.strptime(params[:begin_date], "%Y-%m-%d") rescue nil)
                  ) || default[0]
    @finish_date = (params[:finish_date].present? and
                    (tz.strptime(params[:finish_date], "%Y-%m-%d") rescue nil)
                   ) || default[1]
  end

  def search_executions(executions)
    @during = (params[:during] != '0')
    s = Scheduler::Searcher
    @display_as = s.execution_display_as(params[:display_as])
    s.executions(executions, @display_as, @begin_date, @finish_date, @during, params)
  end

  def add_breadcrumb(name, url, options={})
    @breadcrumbs ||= []
    @breadcrumbs << {name: name, url: url, options: options}
  end

  def set_sentry_context
    if defined?(Sentry)
      Sentry.set_user(id: current_user.id, email: current_user.email) if current_user
      Sentry.set_extras(params: params.except(:action, :controller))
    end
  end

end
