every 1.minutes do
  sidekiq "Scheduler::Runner.check"
end
