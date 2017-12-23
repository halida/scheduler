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

  def search_executions(executions)
    @display_as = ExecutionsController::DISPLAY_AS.keys.include?(params[:display_as]) ? params[:display_as] : 'list'
    case @display_as
    when 'list'
      executions = executions.during(@begin_date, @finish_date+1.day)
    when 'day'
      executions = executions.during(@begin_date, @begin_date+1.day)
    end

    executions = executions.joins(:plan).where("plans.title like ?", "%#{params[:keyword]}%") if params[:keyword]

    executions.preload(:plan, :routine).
      where_if(params[:status].present?, status: params[:status]).
      order(scheduled_at: :asc).
      paginate(page: params[:page])
  end

  def add_breadcrumb(name, url, options={})
    @breadcrumbs ||= []
    @breadcrumbs << {name: name, url: url, options: options}
  end

end
