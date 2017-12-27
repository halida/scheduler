class UserMailer < ApplicationMailer

  def test_email(user)
    mail(to: user.email, subject: "scheduler test email") do |format|
      format.html { render }
    end
  end

  def timeout(users, executions)
    @title = "Execution timeout"
    @executions = executions
    mail(to: users.map(&:email), subject: @title){ |format| format.html{render} }
  end

end
