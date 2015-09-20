Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => "registrations",
    :sessions => "sessions"
  }
  
  root 'links#index'
  get 'allcomments', to: 'comments#all_comments'
  
  resources :links do
    resources :comments
  end
  resources :tos, only: [:index]
end
