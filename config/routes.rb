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

  devise_for :users, controllers: {}, skip: [:sessions]
  scope :users, controller: 'users/sessions' do
    get  :sign_in,  action: :new,     as: :new_user_session
    match :callback,  via: [:get, :post]
    match :sign_off,  via: [:get, :delete], action: :destroy,  as: :destroy_user_session
  end

  resources :applications do
  end

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
