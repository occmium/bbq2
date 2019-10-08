require 'uri'

class Subscription < ApplicationRecord
  belongs_to :event
  # belongs_to :user # не дает анонимно подписаться
  belongs_to :user, optional: true # в отличии от 4го рельса дает

  # Обязательно должно быть событие
  validates :event, presence: true

  # Проверки user_name и user_email выполняются,
  # только если user не задан
  # То есть для анонимных пользователей
  validates :user_name,
            presence: true,
            unless: -> { user.present? }
  validates :user_email,
            presence: true,
            format: {with: URI::MailTo::EMAIL_REGEXP},
            unless: -> { user.present? }

  # Для конкретного event_id один юзер может подписаться только один раз (если юзер задан)
  validates :user, uniqueness: {scope: :event_id}, if: -> { user.present? }

  # Задача 56-1
  # Запрет на подпису юзера на своё событие при такой попытке
  # хелпер absence проверяет атрибут user на отсутствие и
  # возвращает ошибкуб если юзер == создатель_события
  # validates :user,
  #           absence: { message: I18n.t('subscriptions.subscription.cannot_subscribe_to_yourself') },
  #           if: -> { user == event.user }

  # Задача 56-1 Запрет на подпису юзера на своё событие при такой попытке
  # https://goodprogrammer.ru/homework_solutions/11828#answer_49100
  validate :user_narcissism, on: :create

  # Или один email может использоваться только один раз (если анонимная подписка)
  validates :user_email, uniqueness: {scope: :event_id}, unless: -> { user.present? }

  # Задача 56-2 — bqq: запрет приглашения существующих юзеров
  # validates :user_email,
  #           absence: { message: I18n.t('subscriptions.subscription.is_already_registered') },
  #           if: -> {
  #             !user.present? &&
  #             User.all.map(&:email).include?(user_email)
  #           }

  # Задача 56-2 — bqq: запрет приглашения существующих юзеров
  # https://goodprogrammer.ru/homework_solutions/11828#answer_49100
  validate :user_email_exist, on: :create

  # Если есть юзер, выдаем его имя,
  # если нет – дергаем исходный метод
  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  # Если есть юзер, выдаем его email,
  # если нет – дергаем исходный метод
  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  def user_email_exist
    errors.add(
      :user_email,
      I18n.t('subscriptions.subscription.is_already_registered')
    ) if !user.present? && User.all.map(&:email).include?(user_email)
  end

  def user_narcissism
    errors.add(
      :user,
      I18n.t('subscriptions.subscription.cannot_subscribe_to_yourself')
    ) if user == event.user
  end
end
