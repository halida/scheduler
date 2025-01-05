class HomeController < ApplicationController
  before_action :set_breadcrumbs

  def index
    set_tab :dashboard, :nav
    self.check_during([Date.today, Date.today])
    params[:display_as] ||= 'day'
    @executions = self.search_executions(Execution.all).preload(plan: :application)
  end

  def info
    @info = Scheduler::Info.get(current_user)
  end

  def controls
    return if request.get?

    @type = params[:type]
    @result = Scheduler::Controls.run(@type, user: current_user)
    case @type
    when 'execution_check', 'execution_run', 'execution_expand', 'execution_verify'
      render "check_result", status: :see_other
    when 'report_export'
      render json: JSON.pretty_generate(@result), status: :see_other
    else
      redirect_to [:controls, :home], notice: @result[:msg], status: :see_other
    end
  end

  def jobs
  end

  def profile
    if (request.post? and
        current_user.update(
          params.require(:item).permit(
            :timezone, :email_notify,
            :email_daily_report, :email_daily_report_time,
          )))
      flash[:notice] = "Updated."
      redirect_to profile_home_path, status: :see_other
    end
  end

  protected

  def set_breadcrumbs
    add_breadcrumb self.action_name, self.url_for
  end

end
