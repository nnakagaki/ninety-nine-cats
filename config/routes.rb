Rails.application.routes.draw do
  root to: "cats#index"

  # TODO MINIMIZE NUM OF USER/SESSION ROUTES

  resources :users

  resources :cats

  resource :session

  resources :cat_rental_requests, only: [:new, :create] do
    member do
      post "approve"
      post "deny"
    end
  end
end
