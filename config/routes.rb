Rails.application.routes.draw do
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
