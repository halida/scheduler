Rails.application.routes.draw do

  root "home#index"
  resource :home, controller: "home" do
    post :op
  end

  devise_for :users

  resources :plans do
    member do
      get :executions
      post :op
    end
  end
  resources :execution_methods
  resources :routines
  resources :executions do
    member do
      post :op
    end
  end

  resources :users
end
