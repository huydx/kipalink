Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => "registrations",
    :sessions => "sessions"
  }
  
  root 'links#index'

  get 'allcomments', to: 'comments#all_comments'
  
  resources :links do
    resources :comments
    get 'vote', to: 'links#vote'
  end
  resources :tos, only: [:index]
end
