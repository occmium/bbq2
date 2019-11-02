class PhotosController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_photo, only: [:destroy]

  # Обратите внимание: фотку может сейчас добавить даже неавторизованный пользовать
  # Смотрите домашки!
  def create
    # Создаем новую фотографию у нужного события @event
    @new_photo = @event.photos.build(photo_params)

    # Проставляем у фотографии пользователя
    @new_photo.user = current_user

    if @new_photo.save
      # Задача 58-1 — bbq: уведомления о фотографиях по email
      notify_subscribers(@event, @new_photo)

      # Если фотка сохранилась, редиректим на событие с сообщением
      redirect_to @event, notice: I18n.t('controllers.photos.created')
    else
      # Если нет — рендерим событие с ошибкой
      render 'events/show', alert: I18n.t('controllers.photos.error')
    end
  end

  def destroy
    message = {notice: I18n.t('controllers.photos.destroyed')}

    # Проверяем, может ли пользователь удалить фотографию
    # Если может — удаляем
    if current_user_can_edit?(@photo)
      @photo.destroy
    else
      # Если нет — сообщаем ему
      message = {alert: I18n.t('controllers.photos.error')}
    end

    # В любом случае редиректим юзера на событие
    redirect_to @event, message
  end

  private

  # Так как фотография — вложенный ресурс, в params[:event_id] рельсы
  # автоматически положат id события, которому принадлежит фотография
  # Это событие будет лежать в переменной контроллера @event
  def set_event
    @event = Event.find(params[:event_id])
  end

  # Получаем фотографию из базы стандартным методом find
  def set_photo
    @photo = @event.photos.find(params[:id])
  end

  # При создании новой фотографии мы получаем массив параметров photo
  # c единственным полем photo
  def photo_params
    params.fetch(:photo, {}).permit(:photo)
  end

  # Задача 58-1 — bbq: уведомления о фотографиях по email
  def notify_subscribers(event, photo)
    # Собираем всех подписчиков и автора события в массив мэйлов,
    # исключаем мэйл загрузившего фото и повторяющиеся мэйлы
    all_emails = (event.subscriptions.map(&:user_email) +
      [event.user.email] -
      [current_user.email]
    ).uniq

    # По адресам из этого массива делаем рассылку
    # Как и в подписках, берём EventMailer и его метод comment с параметрами
    # И отсылаем в том же потоке
    all_emails.each do |mail|
      # EventMailer.photo(event, photo, mail).deliver_now
      EventMailer.photo(event, photo, mail).deliver_later
      # Для учебных целей прямо тут используем .deliver_now, а не в отдельном
      # рельсоприложении. Будем ждать окончания рассыки прям на странице - в
      # уловиях небольшого числа пользователей этоо можно стерпеть.
      # В реальности рассылку надо выносить в background задачи.
    end
  end
end

# class PhotosController < ApplicationController
#   before_action :set_photo, only: [:show, :edit, :update, :destroy]
#
#   # GET /photos
#   def index
#     @photos = Photo.all
#   end
#
#   # GET /photos/1
#   def show
#   end
#
#   # GET /photos/new
#   def new
#     @photo = Photo.new
#   end
#
#   # GET /photos/1/edit
#   def edit
#   end
#
#   # POST /photos
#   def create
#     @photo = Photo.new(photo_params)
#
#     if @photo.save
#       redirect_to @photo, notice: 'Photo was successfully created.'
#     else
#       render :new
#     end
#   end
#
#   # PATCH/PUT /photos/1
#   def update
#     if @photo.update(photo_params)
#       redirect_to @photo, notice: 'Photo was successfully updated.'
#     else
#       render :edit
#     end
#   end
#
#   # DELETE /photos/1
#   def destroy
#     @photo.destroy
#     redirect_to photos_url, notice: 'Photo was successfully destroyed.'
#   end
#
#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_photo
#       @photo = Photo.find(params[:id])
#     end
#
#     # Only allow a trusted parameter "white list" through.
#     def photo_params
#       params.fetch(:photo, {})
#     end
# end
