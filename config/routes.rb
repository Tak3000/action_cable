Rails.application.routes.draw do
  resources :chatrooms
  devise_for :users
  root to: "chatrooms#index"
  
  resources :users
  
  resources :chatrooms do
    resource :chatroom_users
    resources :messages
  end
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
