Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "home#index"
  
  resources :plans
  resources :execution_methods
  resources :routines
  resources :executions

end
