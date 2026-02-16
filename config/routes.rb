Rails.application.routes.draw do
  root "pages#home"

  resources :users, only: [:new, :create, :index, :show, :destroy, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :projects
  
  get "login", to: "sessions#new", as: "login"
  delete "logout", to: "sessions#destroy", as: "logout"

  get "up" => "rails/health#show", as: :rails_health_check
end
