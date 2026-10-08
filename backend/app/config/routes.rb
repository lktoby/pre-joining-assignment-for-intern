Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "/api/users", to: "users#create"

  get "/api/sessions/new", to: "sessions#new"

  post "/api/sessions", to: "sessions#create"

  get "/api/csrf-token", to: "csrf#show"

  post "/api/tasks", to: "tasks#create"

  get "/api/tasks", to: "tasks#index"

  # Defines the root path route ("/")
  # root "posts#index"
end
