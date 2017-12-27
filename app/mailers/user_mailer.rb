class UserMailer < ApplicationMailer

  def test_email(user)
    mail(to: user.email, subject: "scheduler test email") do |format|
      format.html { render }
    end
  end

end
