Rails.application.routes.draw do
  root to: "cats#index"

  resources :users, only: [:new, :create]

  resources :cats, only: [:new, :create, :edit, :update, :show, :index]

  resource :session, only: [:new, :create, :destroy]

  resources :cat_rental_requests, only: [:new, :create] do
    member do
      post "approve"
      post "deny"
    end
  end
end
