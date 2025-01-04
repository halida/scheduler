require 'ostruct'

class Scheduler::Workflow::Plan < Scheduler::Workflow::Base

  def expand_executions(now)
    @item.routines.where(enabled: true).map do |routine|
      routine.workflow.expand_executions(now)
    end.flatten
  end

  def get_schedules_with_execution_during(from, to)
    executions = @item.executions.during(from, to)
    schedules = \
    @item.routines.map do |routine|
      routine.workflow.get_schedules_during(from, to)
    end.flatten.sort
    self.class.put_executions_to_schedules_gap(executions, schedules)
  end

  def self.put_executions_to_schedules_gap(executions, schedules)
    out = []
    schedules.each_with_index do |s, i|
      s_next = schedules[i+1]
      es = executions.select do |e|
        t = e.scheduled_at || e.started_at
        ((!s or t >= s) and
         (!s_next or t < s_next))
      end
      out << OpenStruct.new(at: s, executions: es)
    end
    out
  end

  def self.notify(params)
    @item = Plan.where.not(token: nil).where(token: params[:plan_id]).first
    return {status: :error, message: "no such plan"} unless @item

    @execution = @item.executions.where(status: :calling).first
    return {status: :error, message: "no current execution"} unless @execution

    @execution.close(params[:status], params[:result])
    return {status: :succeeded, id: @item.id, execution_id: @execution.id}
  end
end
