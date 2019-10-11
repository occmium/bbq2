class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.subscription.subject
  #
  def subscription(event, subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = event

    # @greeting = "Hi"
    # mail to: "to@example.org"

    # Берём у юзер его email
    # Subject тоже можно переносить в локали
    mail to: event.user.email, subject: "Новая подписка на #{event.title}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.comment.subject
  #
  def comment(event, comment, email)
    @comment = comment
    @event = event

    mail to: email, subject: "Новый комментарий @#{event.title}"
    # @greeting = "Hi"
    # mail to: "to@example.org"
  end

  # Задача 58-1 — bbq: уведомления о фотографиях по email
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.photo.subject
  def photo(event, photo, email)
    @photo = photo
    @event = event

    mail to: email, subject: "Новое фото @#{event.title}"
    # @greeting = "Hi"
    # mail to: "to@example.org"
  end
end
