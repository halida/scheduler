class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAIL_FROM"] || 'from@example.com'
  layout 'mailer'
end
