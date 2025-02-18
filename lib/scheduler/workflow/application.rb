class Scheduler::Workflow::Application < Scheduler::Workflow::Base

  def self.notify_plan(params)
    return {status: :error, message: "no such application"} \
      unless @item = self.get(params)

    @plan = @item.plans.where(enabled: true, title: params[:plan_title]).first
    return {status: :error, message: "no such plan"} unless @plan

    @execution = @plan.executions.where(status: :calling).first
    return {status: :error, message: "no current execution"} unless @execution

    @execution.close(params[:status], params[:result])
    return {status: :succeeded, id: @item.id, plan_id: @plan.id,
            execution_id: @execution.id}
  end

  def self.executions(params)
    return {status: :error, message: "no such application"} \
      unless @item = self.get(params)

    items = @item.executions
    if sd = params[:scheduled_during]
      sd = sd.map{|i| Time.at(i.to_i)}
      items = items.scheduled_during(sd[0], sd[1])
    end

    items
  end

  def self.get(params)
    Application.where.not(token: nil).
      where(enabled: true, token: params[:application_id]).first
  end

end
