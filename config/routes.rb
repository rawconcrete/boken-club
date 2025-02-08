# Rails.application.routes.draw do
#   get 'pages/home'
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
#   root 'pages#home'

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

Rails.application.routes.draw do
  root 'pages#home'

  get 'pages/home'
  root 'pages#home'

  resources :travel_plans, only: [:show]

  resources :adventures, only: [:index, :show]

  resources :locations, only: [:index, :show] do
    resources :travel_plans, only: [:new, :create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
