Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post 'auth/login', to: 'authentication#login'

  # Admin namespace for admin-specific functionality
  namespace :admin do
    namespace :vendor do
      get ':vendor_id/profile', to: 'profiles#show'
      get ':vendor_id/products', to: 'products#index'
      get ':vendor_id/products/:product_id/reviews', to: 'reviews#index'
      get ':vendor_id/orders', to: 'orders#index_for_vendor'
      get ':vendor_id/analytics', to: 'analytics#show'
    end

    namespace :purchaser do
      get ':purchaser_id/profile', to: 'profiles#show'
      get ':purchaser_id/orders', to: 'orders#index_for_purchaser'
    end

    resources :orders, only: [:index, :show, :destroy] do
      member do
        put 'on-transit', to: 'orders#update_status_to_on_transit'
      end
    end
    
    resources :categories
    resources :products
    resources :cms_pages
    resources :vendors
    resources :purchasers
    resources :analytics
    resources :reviews
  end

  # Vendor namespace for vendor-specific functionality
  namespace :vendor do
    post 'signup', to: 'vendors#create'
    resources :products
    resources :orders
    resources :shipments
    resources :categories, only: [:index, :show]
    resources :analytics, only: [:index]
    resources :reviews, only: [:index, :show] do
      post 'reply', on: :member
    end      
    resource :profile, only: [:show, :update] 
  end

  # Purchaser namespace for purchaser-specific functionality
  namespace :purchaser, path: 'purchaser' do
    post 'signup', to: 'purchasers#create'

    resource :profile, only: [:show, :update]
    resources :bookmarks, only: [:index, :show, :create, :destroy]   
    resources :cart_items, only: [:index, :create, :destroy] do
      collection do
        post :checkout
      end
    end
    resources :products, only: [:index, :show] do
      member do
        post 'add_to_cart'
      end
    end
    
    resources :orders, only: [:index, :show, :create] do
      member do
        put 'deliver', to: 'orders#update_status_to_delivered'
      end
    end

    resources :reviews
  end
end
