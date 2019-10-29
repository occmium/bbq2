require 'uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
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
    UserMailer.register_new(self).deliver_now
  end
end
