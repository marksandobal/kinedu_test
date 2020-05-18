Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: :api do
    scope module: :v1, constraints: ApiVersionConstraint.new(version: 1) do
      resources :sessions, only: [:create]
    end
  end
end
