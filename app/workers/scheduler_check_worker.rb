class SchedulerCheckWorker
  include Sidekiq::Worker

  # for override the issue
  attr_accessor :jid

  def perform
    Scheduler::Runner.check
  end
end
