class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.register_new.subject
  #
  def register_new(user)
    @user = user

    # @greeting = "Hi"
    # mail to: "to@example.org"

    # Берём у юзер его email
    # Subject тоже можно переносить в локали
    mail to: user.email, subject: "Пользователь #{user.name} зарегистрирован"
  end
end
