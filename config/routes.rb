Rails.application.routes.draw do
  root to: "cats#index"


  # TODO DEAL WITH SETTING DEFAULT CAT IN RENTAL SCREEN
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
