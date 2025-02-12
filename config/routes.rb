# routes.rb
Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  resources :adventures, only: [:index, :show]
  resources :travel_plans, only: [:index, :show, :new, :create]
  resources :locations, only: [:index, :show] do
    resources :travel_plans, only: [:new, :create]
    collection do
      get 'search'
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
 end
