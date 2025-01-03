class SchedulerCheckJob < ApplicationJob
  queue_as :default

  def perform
    Scheduler::Runner.check
  end
end
