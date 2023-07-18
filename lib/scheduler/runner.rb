class Scheduler::Runner
  class << self

    def check(now=nil)
      now ||= DateTime.now

      result = {}
      result[:run_executions] = self.run_executions(now)
      result[:verify_executions] = self.verify_executions(now)
      result[:expand_executions] = self.expand_executions(now) if self.expired(:create_executions, 1.day, now)
      Scheduler::Lib.write_cache(:checked_at, Time.now)
      result
    end

    protected

    def run_executions(now)
      executions = Execution.where(status: :initialize).
                    where("scheduled_at <= ?", now)
      executions.map(&:perform)
      executions
    end

    def expand_executions(now)
      Plan.enabled.map do |plan|
        Scheduler::Lib.plan_expand_executions(plan, now)
      end.flatten.compact.sort_by(&:scheduled_at)
    end

    public def verify_executions(now)
      executions = Execution.where(status: :calling).
                     where("timeout_at <= ?", now)
      return [] if executions.blank?

      executions.each do |e|
        e.update!(status: :timeout, finished_at: now)
      end
      UserMailer.timeout(User.where(email_notify: true), executions).deliver_now
      executions
    end

    def expired(key, duration, now)
      key = "expired_#{key}"
      v = Scheduler::Lib.read_cache(key)
      return false if v and v > now

      Scheduler::Lib.write_cache(key, now + duration)
      return true
    end

  end
end
