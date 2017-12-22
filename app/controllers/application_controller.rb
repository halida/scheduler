class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected

  def check_during(default)
    default.map!{|v| v.in_time_zone(current_user.timezone)}

    tz = ActiveSupport::TimeZone.new(current_user.timezone)
    @begin_date = (params[:begin_date].present? and (tz.strptime(params[:begin_date], "%m/%d/%Y") rescue nil)) || default[0]
    @finish_date = (params[:finish_date].present? and (tz.strptime(params[:finish_date], "%m/%d/%Y") rescue nil)) || default[1]

    # @begin_date = params[:begin_date].blank? ? default[0] : ActiveSupport::TimeZone.new(current_user.timezone).strptime(params[:begin_date], "%m/%d/%Y")
    # @finish_date = params[:finish_date].blank? ? default[1] : ActiveSupport::TimeZone.new(current_user.timezone).strptime(params[:finish_date], "%m/%d/%Y")
  end

  def add_breadcrumb(name, url, options={})
    @breadcrumbs ||= []
    @breadcrumbs << {name: name, url: url, options: options}
  end

end
