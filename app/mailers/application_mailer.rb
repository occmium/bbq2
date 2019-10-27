class ApplicationMailer < ActionMailer::Base
  default from: 'deploy@occmium.online'
  layout 'mailer'
end
