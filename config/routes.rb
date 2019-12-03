Rails.application.routes.draw do

  root "home#index"
  get "/live-ping" => "home#live_ping"
  get "/check" => "home#check"
  
  resource :home, controller: "home" do
    match :op, via: [:get, :post]
    post :notify
    get :sidekiq
    get :info
    match :profile, via: [:get, :post]
  end

  namespace :api do
    resource :op, controller: "op" do
      get :ping
      get :testing_worker
    end
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

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
