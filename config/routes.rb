# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  # profile routes
  resource :profile, only: [:show, :edit, :update]

  # user equipment routes
  resources :user_equipments, only: [:create, :update, :destroy]

  resources :adventures, only: [:index, :show] do
    collection do
      get :index, format: :json
    end
  end

  resources :skills, only: [:index, :show] do
    collection do
      get :index, format: :json
    end
  end

  resources :locations, only: [:index, :show] do
    collection do
      get :index, format: :json
    end
  end

  resources :travel_plans do
    collection do
      get :get_recommended_equipment
      get :get_recommended_skills
    end
    member do
      delete :destroy
      post :mark_equipment_purchased
      post :add_skill      # add this line
      delete :remove_skill # add this line

      # equipment status updates
      patch 'equipment/:equipment_id', to: 'travel_plans#update_equipment_status', as: :update_equipment
    end
  end

  get '/search', to: 'search#index'


  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    resources :locations, only: [:new, :create, :edit, :update, :destroy]
    resources :adventures, only: [:new, :create, :edit, :update, :destroy]
    get 'dashboard', to: 'admin#dashboard'
    resources :skills do
      member do
        get :associations
        patch :update_adventure_associations
        patch :update_location_associations
      end
    end
  end

  resources :quizzes, only: [:index, :show] do
    member do
      get :take
      post :submit
    end
  end

  get 'quiz_result/:id', to: 'quizzes#result', as: :quiz_result

  get '/search', to: 'search#index'

  resources :equipment, only: [:index, :show] do
    collection do
      get :search
    end
  end

end
