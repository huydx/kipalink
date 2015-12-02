Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => "registrations",
    :sessions => "sessions"
  }

  root 'links#index'
  get 'newlinks', to: 'links#newlinks'

  resources :links do
    resources :comments
    get 'vote', to: 'links#vote'
  end

  resources :comments do
    resources :reply, only: [:new, :create]
  end

  resources :tos, only: [:index]
end
