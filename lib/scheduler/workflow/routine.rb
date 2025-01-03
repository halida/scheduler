class Scheduler::Workflow::Routine < Scheduler::Workflow::Base

  def expand_executions(now)
    last = @item.executions.order(scheduled_at: :desc).first.try(:scheduled_at) || now
    last = now if last < now

    # create next 2 week execution when near 1 week
    return if last > now + 7.days
    to = [last, now].max + 14.days

    status = @item.plan.review_only ? :succeeded : :init
    schedules = self.get_schedules_during(last, to)
    schedules.map do |schedule|
      @item.executions.find_or_create_by!(
        plan_id: routine.plan.id,
        scheduled_at: schedule,
        status: status,
      )
    end
  end

  def get_schedules_during(from, to)
    Scheduler::Lib.get_schedules_during(
      @item.config, @item.timezone, from, to, modify: @item.modify)
  end

end
