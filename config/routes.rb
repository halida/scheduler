Rails.application.routes.draw do

  root "home#index"
  devise_for :users
  
  resources :plans
  resources :execution_methods
  resources :routines
  resources :executions

  resources :users
end
