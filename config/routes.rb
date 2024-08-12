
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
    resources :products do
      collection do
        get 'search'
        get 'flagged'
      end
      member do
        patch 'flag'
        patch 'restore'
      end
    end
    resources :cms_pages
    resources :vendors do
      member do
        put 'block'
        put 'unblock'
        get 'analytics'
        get 'orders', to: 'vendors#orders'
        get 'products'
        get 'reviews'
      end
    end

    resources :purchasers do
      member do
        put 'block'
        put 'unblock'
      end
    end

    resources :conversations, only: [:index, :show, :create] do
      resources :messages, only: [:index, :create]
    end
    resources :analytics
    resources :reviews
    resources :abouts
    resources :faqs
    resources :promotions, except: [:new, :edit]
    get 'identify', to: 'admins#identify'
    resources :notifications, only: [:create]
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
      collection do
        get 'search'
      end

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

  mount ActionCable.server => '/cable'
end
