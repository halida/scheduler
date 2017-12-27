class SchedulerCheckWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    Scheduler::Runner.check
  end
end
