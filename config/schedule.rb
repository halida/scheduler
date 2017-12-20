job_type :sidekiq,  'cd :path && RAILS_ENV=:environment bundle exec sidekiq-client push ScheduledWorker[:task] :output'

every 1.minutes do
  sidekiq "Scheduler::Runner.check"
end
