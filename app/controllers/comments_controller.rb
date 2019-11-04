class CommentsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]

  # # GET /comments
  # def index
  #   @comments = Comment.all
  # end
  #
  # # GET /comments/1
  # def show
  # end
  #
  # # GET /comments/new
  # def new
  #   @comment = Comment.new
  # end
  #
  # # GET /comments/1/edit
  # def edit
  # end

  # POST /comments
  # def create
  #   @comment = Comment.new(comment_params)
  #
  #   if @comment.save
  #     redirect_to @comment, notice: 'Comment was successfully created.'
  #   else
  #     render :new
  #   end
  # end

  def create
    # Создаём объект @new_comment из @event
    @new_comment = @event.comments.build(comment_params)
    # Проставляем пользователя, если он задан
    @new_comment.user = current_user

    if @new_comment.save
      # уведомляем всех подписчиков о новом комментарии
      notify_subscribers(@event, @new_comment)

      # Если сохранился, редирект на страницу самого события
      redirect_to @event, notice: I18n.t('controllers.comments.created')
    else
      # Если ошибки — рендерим здесь же шаблон события (своих шаблонов у коммента нет)
      render 'events/show', alert: I18n.t('controllers.comments.error')
    end
  end

  # # PATCH/PUT /comments/1
  # def update
  #   if @comment.update(comment_params)
  #     redirect_to @comment, notice: 'Comment was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /comments/1
  # def destroy
  #   @comment.destroy
  #   redirect_to comments_url, notice: 'Comment was successfully destroyed.'
  # end

  def destroy
    message = {notice: I18n.t('controllers.comments.destroyed')}

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = {alert: I18n.t('controllers.comments.error')}
    end

    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  # Комментарий будем искать не по всей базе,
  # а у конкретного события
  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    # params.fetch(:comment, {})
    params.require(:comment).permit(:body, :user_name)
  end

  # Задача 58-2 — bbq: автор коммента не получает о нем письмо
  def notify_subscribers(event, comment)
    # Собираем всех подписчиков и автора события в массив мэйлов,
    # исключаем повторяющиеся исключаем мэйл комментатора(если мэйл
    # существует - например залогиненный/незалогиненный пользователь)
    all_emails = (event.subscriptions.map(&:user_email) +
      [event.user.email] -
      # [current_user.try(:email)]
      [comment.user.try(:email)]
    ).uniq
    # Eugene's comment
    # https://goodprogrammer.ru/homework_solutions/11946#answer_49649
    # > © Во-первых, после такого изменения метод можно будет из контролера
    # > куда-нибудь утащить в другой класс. Во-вторых, в будущем может
    # > появиться возможность админу, например, оставлять или редактировать
    # > комменты других юзеров или что-то вроде того.

    # По адресам из этого массива делаем рассылку
    # Как и в подписках, берём EventMailer и его метод comment с параметрами
    # И отсылаем в том же потоке
    all_emails.each do |mail|
      # EventMailer.comment(event, comment, mail).deliver_now
      # EventMailer.comment(event, comment, mail).deliver_later
      # Для учебных целей прямо тут используем .deliver_now, а не в отдельном
      # рельсоприложении. Будем ждать окончания рассыки прям на странице - в
      # уловиях небольшого числа пользователей этоо можно стерпеть.
      # В реальности рассылку надо выносить в background задачи.
      TransmitterCommentsJob.perform_later(event, comment, mail)
      # В контроллере создается 1 задача - "отправь всем подписчикам события
      # уведомление", а уже в ней отправляются письма (причем в идеале так же
      # через deliver_later)
      # Это актуально для фото и для комментов. Для новой подписки, где
      # отправляется одно письмо только автору эвента - это не актуально.
    end
  end
end
