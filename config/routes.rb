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

  resources :travel_plans, except: [:destroy] do
    member do
      delete :destroy
    end
  end

  get '/search', to: 'search#index'


  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    resources :locations, only: [:new, :create, :edit, :update, :destroy]
    resources :adventures, only: [:new, :create, :edit, :update, :destroy]
    get 'dashboard', to: 'admin#dashboard'
  end

  # add for equipments
  resources :equipment
  resources :user_equipments, only: [:create, :destroy]

  resources :travel_plans do
    member do
      post 'add_item'
    end
  end

end
