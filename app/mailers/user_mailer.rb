class UserMailer < ApplicationMailer
  helper ApplicationHelper

  def test(user)
    mail(to: user.email, subject: "scheduler test email") do |format|
      format.html { render }
    end
  end

  def timeout(users, executions)
    @users = users
    @title = "[Scheduler] Execution timeout"
    @executions = executions
    mail(to: users.map(&:email), subject: @title){ |format| format.html{render} }
  end

  def daily_report(user, data)
    @title = "[Scheduler] Daily Report: #{data.count}"
    @title += " Errors: #{data.error_count}" if data.error_count > 0
    @user = user
    @data = data
    mail(to: user.email, subject: @title){ |format| format.html{render} }
  end

end
