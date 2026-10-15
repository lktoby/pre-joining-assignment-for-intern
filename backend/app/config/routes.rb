Rails.application.routes.draw do
  get "follows/create"
  get "follows/destroy"
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

  put "/api/tasks/:task_id/complete", to: "tasks#complete"

  put "/api/tasks/:task_id/incomplete", to: "tasks#incomplete"

  post "/api/tasks/:task_id/favorite", to: "favorite_tasks#create"

  delete "/api/tasks/:task_id/favorite", to: "favorite_tasks#destroy"

  put "/api/users/follow/:target_user_id", to: "follows#create"

  delete "/api/users/follow/:target_user_id", to: "follows#destroy"

  # Defines the root path route ("/")
  # root "posts#index"
end
