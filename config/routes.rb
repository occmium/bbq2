Rails.application.routes.draw do
  devise_for :users, controllers: {
    # registrations: 'registrations', # to_do_...
    # registrations: 'users/registrations', # to_do_...
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root "events#index"

  resources :events do
    # вложенный ресурс комментов
    resources :comments, only: [:create, :destroy]
    # вложенный ресурс подписок
    resources :subscriptions , only: [:create, :destroy]
    # Вложенные в ресурс события ресурсы фотографий
    resources :photos, only: [:create, :destroy]
    # Пост запрос по пути events#show
    post :show, on: :member
  end
  resources :users, only: [:show, :edit, :update]
end
