Rails.application.routes.draw do

  root "home#index"
  resource :home, controller: "home" do
    post :op
    post :notify
  end

  namespace :api do
    resources :plans do
      post :notify
    end
    resources :executions do
      post :notify
    end
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
