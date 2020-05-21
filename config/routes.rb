Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    scope module: :v1, constraints: ApiVersionConstraint.new(version: 1) do
      resources :sessions, only: [:create]
      resources :users, only: [:index,:show,:create,:update]

      resources :activities, only: [:index,:show]
      resources :activity_logs, only: [:index,:create,:update]
      resources :assistants, only: [:index,:show,:create,:update, :destroy]
      resources :babies do
        member do
          get 'activity_logs', to: 'activity_logs#baby_activity_logs'
        end
      end

      get 'babies', to: 'babies#index'
    end
  end
end
