job_type :enqueue, "bin/rake job=:task jobs:enqueue"

every 1.minutes do
  enqueue "SchedulerCheckJob"
end
every "2 * * * *" do
  enqueue "DailyReportJob"
end
