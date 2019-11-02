class SubscriptionsController < ApplicationController
  # before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  # Задаем родительский event для подписки
  before_action :set_event, only: [:create, :destroy]
  # Задаем подписку, которую юзер хочет удалить
  before_action :set_subscription, only: [:destroy]

  # # GET /subscriptions
  # def index
  #   @subscriptions = Subscription.all
  # end
  #
  # # GET /subscriptions/1
  # def show
  # end
  #
  # # GET /subscriptions/new
  # def new
  #   @subscription = Subscription.new
  # end
  #
  # # GET /subscriptions/1/edit
  # def edit
  # end

  # POST /subscriptions
  # def create
  #   @subscription = Subscription.new(subscription_params)
  #
  #   if @subscription.save
  #     redirect_to @subscription, notice: 'Subscription was successfully created.'
  #   else
  #     render :new
  #   end
  # end

  def create
    # Болванка для новой подписки
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    if @new_subscription.save
      # Если сохранилось, отправляем письмо
      # Пишем название класса, потом метода и передаём параметры
      # И доставляем методом .deliver_now (то есть в этом же потоке)
      # EventMailer.subscription(@event, @new_subscription).deliver_now
      EventMailer.subscription(@event, @new_subscription).deliver_later
      # Для учебных целей прямо тут используем .deliver_now, а не в отдельном
      # рельсоприложении. Будем ждать окончания рассыки прям на странице - в
      # уловиях небольшого числа пользователей этоо можно стерпеть.
      # В реальности рассылку надо выносить в background задачи.

      # Если сохранилась, редиректим на страницу самого события
      redirect_to @event, notice: I18n.t('controllers.subscriptions.created')
    else
      # если ошибки — рендерим шаблон события
      render 'events/show', alert: I18n.t('controllers.subscriptions.error')
    end
  end

  # # PATCH/PUT /subscriptions/1
  # def update
  #   if @subscription.update(subscription_params)
  #     redirect_to @subscription, notice: 'Subscription was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /subscriptions/1
  # def destroy
  #   @subscription.destroy
  #   redirect_to subscriptions_url, notice: 'Subscription was successfully destroyed.'
  # end

  def destroy
    message = {notice: I18n.t('controllers.subscriptions.destroyed')}
    if current_user_can_edit?(@subscription)
      @subscription.destroy
    else
      message = {alert: I18n.t('controllers.subscriptions.error')}
    end

    redirect_to @event, message
  end

  private

  # # Use callbacks to share common setup or constraints between actions.
  # def set_subscription
  #   @subscription = Subscription.find(params[:id])
  # end

  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  # Only allow a trusted parameter "white list" through.
  def subscription_params
    # .fetch разрешает в params отсутствие ключа :subscription
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end
end
