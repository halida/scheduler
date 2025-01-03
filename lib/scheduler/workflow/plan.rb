class Scheduler::Workflow::Plan < Scheduler::Workflow::Base

  def expand_executions(now)
    @item.routines.where(enabled: true).map do |routine|
      routine.workflow.expand_executions(now)
    end.flatten
  end

  def notify(params)
    @item = Plan.where.not(token: nil).where(token: params[:plan_id]).first
    return {status: :error, message: "no such plan"} unless @item

    @execution = @item.executions.where(status: :calling).first
    return {status: :error, message: "no current execution"} unless @execution

    @execution.close(params[:status], params[:result])
    {status: :succeeded, id: @item.id, execution_id: @execution.id}
  end
end
