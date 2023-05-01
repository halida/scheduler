class DailyReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    now = Time.now
    User.where(email_daily_report: true).each do |u|
      runs_at = now.in_time_zone(u.timezone).change(hour: u.email_daily_report_time)
      last_checked_at = u.email_daily_report_checked_at || runs_at - 3.days # first don't check too long ago
      next unless runs_at != last_checked_at and runs_at < now

      executions = Execution.during(last_checked_at, runs_at).
                     order(started_at: :asc)
      data = OpenStruct.new(
        executions: executions,
        count: executions.count,
        error_count: executions.errors.count,
      )

      u.update(email_daily_report_checked_at: runs_at)
      UserMailer.daily_report(u, data).deliver_now
    end
  end
end
