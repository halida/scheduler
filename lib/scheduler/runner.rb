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
      Execution.where(status: :initialize).
        where("scheduled_at <= ?", now).
        map(&:perform)
    end

    def expend_executions(now)
      Routine.enabled.each do |routine|
        Lib.routine_expend_executions(routine, now)
      end
    end

    public def verify_executions(now)
      Execution.where(status: :calling).
        where("timeout_at <= ?", now).
        update_all(status: :timeout)
    end

    def close_calling_executions(now)
      Execution.where(status: :calling).each do |e|
        if e.started_at + e.scheduler.waiting.seconds < now
          e.status = :timeout
          e.save!
        end
      end
    end

  end
end
