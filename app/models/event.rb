class Event < ApplicationRecord
  # Событие принадлежит юзеру
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  # Чтобы Рельсы понимали, какой именно класс будет лежать
  # в модели subscribers, надо указать source
  has_many :subscribers, through: :subscriptions, source: :user
  has_many :photos, dependent: :destroy

  validates :user, presence: true
  validates :title, presence: true, length: {maximum: 255}
  validates :address, presence: true
  validates :datetime, presence: true

  def visitors
    (subscribers + [user]).uniq
  end

  # проверить, совпадает ли введённый пин-код с заданным
  def pincode_valid?(pin_to_check)
    pincode == pin_to_check
  end
end
