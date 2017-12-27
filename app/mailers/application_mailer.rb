class ApplicationMailer < ActionMailer::Base
  default from: Settings[:mail_from] || 'from@example.com'
  layout 'mailer'
end
