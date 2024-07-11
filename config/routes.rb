Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post 'auth/login', to: 'authentication#login'

  # Admin namespace for admin-specific functionality
  namespace :admin do
    resources :vendors do
      resources :products, only: [:index]
      resources :reviews, only: [:index]
    end
    resources :purchasers do
      resources :orders, only: [:index]
    end
    resources :orders, only: [:index, :show, :update, :destroy]
    resources :categories
    resources :cms_pages

    get 'analytics', to: 'analytics#index'
  end

  # Vendor namespace for vendor-specific functionality
  namespace :vendor do
    post 'signup', to: 'vendors#signup'
    post 'login', to: 'authentication#login'

    resources :products
    resources :orders do
      member do
        patch 'update_status'
      end
    end
    resources :shipments
    resources :categories, only: [:index, :show]
    resources :analytics, only: [:index]
    get 'reviews', to: 'reviews#index'
    resources :profiles, only: [:update]
  end

  # Routes for vendors and purchasers
  resources :orders, only: [:index, :show, :create, :update, :destroy]
  resources :products
  resources :purchasers, only: [:index, :show, :create, :update, :destroy]
  resources :vendors, only: [:index, :show, :create, :update, :destroy]
  resources :reviews, only: [:index, :show, :create, :update, :destroy]
end
