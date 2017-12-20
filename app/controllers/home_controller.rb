class HomeController < ApplicationController

  def index
    set_tab :dashboard, :nav
  end

  def op
    case params[:type]
    when "run_executions", "expend_executions", "verify_executions"
      executions = Scheduler::Runner.send(params[:type], Time.now)
      executions = executions.paginate(per_page: 1000, page: 1)
      flash[:notice] = "Finished."
      render "executions/_list", locals: {items: executions}
    end
  end

end
