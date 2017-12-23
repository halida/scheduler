class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected

  def check_during(default)
    default.map!{|v| v.in_time_zone(current_user.timezone)}

    tz = ActiveSupport::TimeZone.new(current_user.timezone)
    @begin_date = (params[:begin_date].present? and (tz.strptime(params[:begin_date], "%Y-%m-%d") rescue nil)) || default[0]
    @finish_date = (params[:finish_date].present? and (tz.strptime(params[:finish_date], "%Y-%m-%d") rescue nil)) || default[1]
  end

  def search_executions(executions)
    @during = (params[:during] != '0')
    @display_as = ExecutionsController::DISPLAY_AS.keys.include?(params[:display_as]) ? params[:display_as] : 'list'
    case @display_as
    when 'list'
      executions = executions.during(@begin_date, @finish_date+1.day) if @during
      executions = executions.paginate(page: params[:page])
    when 'day'
      executions = executions.during(@begin_date, @begin_date+1.day)
    end

    executions = executions.joins(:plan).where("plans.title like ?", "%#{params[:keyword]}%") if params[:keyword]

    executions.preload(:plan, :routine).
      where_if(params[:status].present?, status: params[:status]).
      order(scheduled_at: :asc)
  end

  def add_breadcrumb(name, url, options={})
    @breadcrumbs ||= []
    @breadcrumbs << {name: name, url: url, options: options}
  end

end
