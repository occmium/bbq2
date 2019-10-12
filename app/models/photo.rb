class Photo < ApplicationRecord
  belongs_to :event
  belongs_to :user

  # проверка на предмет существования загружаемой фотографии при сабмите
  validates :photo, presence: true

  # В 5-х Рельсах эти валидации не нужно явно прописывать
  # validates :event, presence: true
  # validates :user, presence: true

  mount_uploader :photo, PhotoUploader

  # Scope нужен, чтобы отделить реальные фотки от болванки,
  # которую мы прописали в контроллере событий
  scope :persisted, -> { where "id IS NOT NULL" }
end
