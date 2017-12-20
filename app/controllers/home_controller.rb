class HomeController < ApplicationController

  def index
    set_tab :dashboard, :nav
  end

  def op
    case params[:type]
    when "check", "run_executions", "expend_executions", "verify_executions"
      @now = Time.now
      @result = Scheduler::Runner.send(params[:type], @now)
      render "check_result"
    end
  end

end
