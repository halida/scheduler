class Api::ApplicationsController < ApiController

  def notify_plan
    render json: Scheduler::Workflow::Application.notify_plan(params)
  end

  def executions
    render json: Scheduler::Workflow::Application.executions(params)
  end

end
