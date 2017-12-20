class Scheduler::Runner
  class << self

    def check(now=nil)
      now ||= DateTime.now

      self.run_executions(now)
      self.verify_executions(now)
      self.expend_executions(now) if self.expired(:create_executions, 1.day, now)
    end

    protected

    def run_executions(now)
      executions = Execution.where(status: :initialize).
                    where("scheduled_at <= ?", now)
      executions.map(&:perform)
      executions
    end

    def expend_executions(now)
      Routine.enabled.map do |routine|
        Scheduler::Lib.routine_expend_executions(routine, now)
      end.flatten.compact.sort_by(&:scheduled_at)
    end

    public def verify_executions(now)
      executions = Execution.where(status: :calling).
                     where("timeout_at <= ?", now)
      executions.update_all(status: :timeout, finished_at: now)
      executions
    end

  end
end
