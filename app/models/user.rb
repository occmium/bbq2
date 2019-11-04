require 'uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:vkontakte]

  # Юзер может создавать много событий
  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true, length: {maximum: 35}

  validates :email, presence: true, length: {maximum: 255}
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates :email, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/

  # При создании нового юзера (create), перед валидацией объекта выполнить
  # метод set_name
  before_validation :set_name, on: :create

  # Добавим в модель юзера фильтр:
  after_commit :link_subscriptions, on: :create
  # Мы использовали уже не привычный нам before_action, а after_commit,
  # чтобы быть уверенными, что все валидации прошли и юзер в базе.

  # to do
  after_create :notify_new_user, on: :create
  # https://goodprogrammer.ru/homework_solutions/12259#answer_50940
  # а вот так НИКОГДА не делайте.
  # Представьте себе ситуацию, приложение растет, пользоватаели множатся и
  # надо переехать на сервер помощнее. Вы делаете дамп данных, разворачиваете
  # приложение на новом сервере, импортируете. В новой базе создаются
  # пользователи, тысячи пользователей и сервер отправляет тысячи писем о
  # регистрации пользователям, которые уже давно зарегистрированы и даже о
  # переезде на новый сервер ничего не знают. Ну а ваш домен быстренько
  # попадает в список потенциальных спамеров)
  # Отправку письма делайте только в контроллерах и сервис-объектах.
  # Никогда не отправляйте письма в хуках модели
  # Добавим в модель юзера отправку почты после создания:

  # Аплоадер нужно добавить к модели юзеры
  mount_uploader :avatar, AvatarUploader

  private

  def set_name
    self.name = "Новый пользователь (#{rand(777)})" if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
      .update_all(user_id: self.id)
  end

  def notify_new_user
    # UserMailer.register_new(self).deliver_now
    UserMailer.register_new(self).deliver_later
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.find_for_vkontakte_oauth(access_token)
    # byebug # мне в помощь
    # email = "#{access_token.extra.raw_info.id}_across@vkontakte.asdf"
    # правка 71-1 по наводке Александра
    # https://goodprogrammer.ru/homework_solutions/12356#answer_51403
    email = access_token.info.email
    user = where(email: email).first
    name =  access_token.info.first_name

    return user if user.present?

    provider = access_token.provider
    url = access_token.info.urls.Vkontakte

    where(url: url, provider: provider).first_or_create! do |user|
      user.email = email
      user.password = Devise.friendly_token.first(16)
      user.name = name
    end
  end
end
