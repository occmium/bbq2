class ApplicationController < ActionController::Base
  # Позволяем использовать возможности
  # пандита во всех контроллерах
  include Pundit

  # Настройка для работы девайза при правке профиля юзера
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Хелпер будет доступен во всех вьюхах
  helper_method :current_user_can_edit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Настройка для девайза — разрешаем обновлять профиль, но обрезаем
  # параметры, связанные со сменой пароля.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  # def current_user_can_edit?(event)
  #   user_signed_in? && event.user == current_user
  # end

  def current_user_can_edit?(model)
    # Если у модели есть юзер и он залогиненный, пробуем у неё взять .event
    # Если он есть, проверяем его юзера на равенство current_user.
    user_signed_in? && (
    model.user == current_user ||
      (model.try(:event).present? && model.event.user == current_user)
    )
  end

  def user_not_authorized
    flash[:alert] = t('pundit.not_authorized')
    redirect_to(request.referrer || root_path)
  end
end
