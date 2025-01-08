Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  resource :home, controller: "home" do
    match :controls, via: [:get, :post]
    get :info, :jobs
    match :profile, via: [:get, :post]
  end

  namespace :api do
    resources :applications do
      post :notify_plan
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

  resources :applications

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

  authenticate :user, lambda { |u| u.admin? } do
    mount MissionControl::Jobs::Engine, at: "/jobs"
  end
end
