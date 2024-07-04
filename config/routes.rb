Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post 'auth/login', to: 'authentication#login'

  # Defines the root path route ("/")
  # root "posts#index"

  # Admin namespace for admin-specific functionality
  namespace :admin do
    resources :vendors
    resources :purchasers
    resources :orders
    resources :products
    resources :reviews
    resources :categories
    resources :shipments
    resources :invoices
  end

  # Vendor namespace for vendor-specific functionality
  namespace :vendor do
    resources :products
    resources :orders
    resources :shipments
    resources :reviews
    resources :purchasers, only: [:index, :show]
    resources :invoices
    resources :categories, only: [:index, :show]
  end

  # Routes for vendors and purchasers
  resources :orders, only: [:index, :show, :create, :update, :destroy]
  resources :products
  resources :purchasers, only: [:index, :show, :create, :update, :destroy]
  resources :vendors, only: [:index, :show, :create, :update, :destroy]
  resources :reviews, only: [:index, :show, :create, :update, :destroy]
end
