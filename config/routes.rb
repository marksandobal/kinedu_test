Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    scope module: :v1, constraints: ApiVersionConstraint.new(version: 1) do
      resources :sessions, only: [:create]
      resources :users, only: [:index,:show,:create,:update]

      resources :activity_logs, only: [:index,:create,:update]
      resources :babies do
        member do
          get 'activity_logs', to: 'activity_logs#baby_activity_logs'
        end
      end

      get 'activities', to: 'activities#index'
      get 'babies', to: 'babies#index'
    end
  end
end
