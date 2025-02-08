Rails.application.routes.draw do
  get 'user_equipments/create'
  get 'travel_plans/new'
  get 'travel_plans/create'
  get 'travel_plans/show'
  get 'adventures/index'
  get 'adventures/show'
  get 'locations/index'
  get 'locations/show'
  devise_for :users
  root 'pages#home'

  get 'pages/home'

  resources :travel_plans, only: [:show]

  resources :adventures, only: [:index, :show]

  resources :locations, only: [:index, :show] do
    resources :travel_plans, only: [:new, :create]
    collection do
      get 'search'  # Search route for locations here
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
