Rails.application.routes.draw do
  devise_for :users
  root "events#index"

  resources :events do
    # вложенный ресурс комментов
    resources :comments, only: [:create, :destroy]
    # вложенный ресурс подписок
    resources :subscriptions , only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :update]
end
