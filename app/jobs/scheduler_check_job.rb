class SchedulerCheckJob
  queue_as :default

  def perform
    Scheduler::Runner.check
  end
end
