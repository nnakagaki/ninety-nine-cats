Rails.application.routes.draw do
  root to: "cats#index"

  resources :cats

  # TODO DEAL WITH SETTING DEFAULT CAT IN RENTAL SCREEN

  resources :cat_rental_requests, only: [:new, :create] do
    member do
      post "approve"
      post "deny"
    end
  end
end
