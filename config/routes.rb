Rails.application.routes.draw do
  get 'pages/home'
  get 'pages/restricted'
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :recipes, only: [:index, :show, :create, :update, :destroy]
      end
      resources :ingredients, only: [:index]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
