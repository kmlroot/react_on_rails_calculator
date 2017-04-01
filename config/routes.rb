Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :simulations, only: [:new, :create]
  root to: "home#index"
end
