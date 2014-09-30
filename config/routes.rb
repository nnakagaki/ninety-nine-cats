Rails.application.routes.draw do
  root to: "cats#index"

  resources :cats

  resources :cat_rental_requests

end
