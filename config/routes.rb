# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  resources :adventures, only: [:index, :show] do
    collection do
      get :index, format: :json
    end
  end

  resources :locations, only: [:index, :show] do
    collection do
      get :index, format: :json
    end
  end

  resources :travel_plans, only: [:index, :show, :new, :create]

  get '/search', to: 'search#index'


  get "up" => "rails/health#show", as: :rails_health_check
end
