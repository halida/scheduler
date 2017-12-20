class Scheduler::Runner
  class << self

    def check(now=nil)
      now ||= DateTime.now

      result = {}
      result[:run_executions] = self.run_executions(now)
      result[:verify_executions] = self.verify_executions(now)
      result[:expend_executions] = self.expend_executions(now) if self.expired(:create_executions, 1.day, now)
      result
    end

    protected

    def run_executions(now)
      executions = Execution.where(status: :initialize).
                    where("scheduled_at <= ?", now)
      executions.map(&:perform)
      executions
    end

    def expend_executions(now)
      Plan.enabled.map do |plan|
        Scheduler::Lib.plan_expend_executions(plan, now)
      end.flatten.compact.sort_by(&:scheduled_at)
    end

    public def verify_executions(now)
      executions = Execution.where(status: :calling).
                     where("timeout_at <= ?", now)
      executions.update_all(status: :timeout, finished_at: now)
      executions
    end

    def expired(key, duration, now)
      key = "scheduler_runner_#{key}"
      v = Rails.cache.read(key)
      return false if v and Marshal.load(v) > now
      Rails.cache.write(key, Marshal.dump(now + duration))
      return true
    end

  end
end
