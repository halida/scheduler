class Api::PlansController < ApiController

  def notify
    render json: Scheduler::Workflow::Plan.notify(params)
  end

end
