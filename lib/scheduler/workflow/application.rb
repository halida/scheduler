class Scheduler::Workflow::Application < Scheduler::Workflow::Base

  def self.notify_plan(params)
    @item = Application.where.not(token: nil).
              where(enabled: true, token: params[:application_id]).first
    return {status: :error, message: "no such application"} unless @item

    @plan = @item.plans.where(enabled: true, title: params[:plan_title]).first
    return {status: :error, message: "no such plan"} unless @plan

    @execution = @plan.executions.where(status: :calling).first
    return {status: :error, message: "no current execution"} unless @execution

    @execution.close(params[:status], params[:result])
    render {status: :succeeded, id: @item.id, plan_id: @plan.id,
            execution_id: @execution.id}
  end

end
