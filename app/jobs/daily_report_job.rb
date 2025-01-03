class DailyReportJob < ApplicationJob
  queue_as :default

  def perform(opt={})
    now = Time.now
    users = User.where(email_daily_report: true)
    users = users.where(id: opt[:user_ids]) if opt[:user_ids]
    users.each do |u|
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

      u.update!(email_daily_report_checked_at: runs_at) unless opt[:update] == false
      UserMailer.daily_report(u, data).deliver_now
    end
  end
end
