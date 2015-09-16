Rails.application.routes.draw do
  root 'link#index'
  resource :links
end
