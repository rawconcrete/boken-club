Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  get 'pages/home'

  resources :travel_plans, only: [:show]

  resources :adventures, only: [:index, :show]

  resources :locations, only: [:index, :show] do
  resources :travel_plans, only: [:new, :create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
