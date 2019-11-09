# Задача 70-1 — bbq: с отправкой писем на ActiveJob
class NotificationTransmitterJob < ApplicationJob
  queue_as :default

  def perform(event_mailer_method, reason)
    event = reason.event
    all_emails = (event.subscriptions.map(&:user_email) +
      [event.user.email] -
      [reason.user.try(:email)]
    ).uniq

    temp_var = EventMailer.method(event_mailer_method)
    all_emails.each { |mail| temp_var.call(event, reason, mail).deliver_later }
  end
end
