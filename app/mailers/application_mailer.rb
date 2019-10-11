class ApplicationMailer < ActionMailer::Base
  # default from: 'ramantimov@gmail.com'
  # default from: 'no_reply@suppo.rt'
  # default from: 'omskattitude@narod.ru'
  default from: 'support_noreply@bbqoccmium.herokuapp.com'
  layout 'mailer'
end
