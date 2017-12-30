job_type :sidekiq,  'cd :path && RAILS_ENV=:environment bundle exec sidekiq-client push :task :output'

every 1.minutes do
  sidekiq "SchedulerCheckWorker"
end
every "2 * * * *" do
  sidekiq "DailyReportWorker"
end
