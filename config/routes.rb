
Rails.application.routes.draw do

  root to: 'application#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post 'auth/login', to: 'authentication#login'
  resources :banners, only: [:index]
  resources :ads, only: [:index, :show] do
    get 'reviews', to: 'reviews#index', on: :member
  end
  

  # Routes for logging ad searches
  resources :ad_searches, only: [:create]

  # Routes for logging click events
  resources :click_events, only: [:create]
  resources :incomes, only: [:index]
  resources :sectors, only: [:index]
  resources :educations, only: [:index]
  resources :employments, only: [:index]
  

  #========================================Admin namespace for admin-specific functionality==========================================#
  namespace :admin do
    namespace :vendor do
      get ':vendor_id/profile', to: 'profiles#show'
      get ':vendor_id/ads', to: 'ads#index'
      get ':vendor_id/ads/:ad_id/reviews', to: 'reviews#index'
      get ':vendor_id/orders', to: 'orders#index_for_vendor'
    end

    namespace :purchaser do
      get ':purchaser_id/profile', to: 'profiles#show'
      get ':purchaser_id/orders', to: 'orders#index_for_purchaser'
    end

    namespace :rider do
      get ':rider_id/profile', to: 'profiles#show'
      get ':rider_id/orders', to: 'orders#index_for_rider'
    end

    resources :orders, only: [:index, :show, :destroy] do
      member do
        put 'update-status', to: 'orders#update_status'
      end
    end
    
    resources :categories
    resources :subcategories
    resources :ads do
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
        get 'ads'
        get 'reviews'
      end
    end

    resources :purchasers do
      member do
        put 'block'
        put 'unblock'
      end
    end

    resources :riders do 
      member do
        put 'block'
        put 'unblock'
        put 'assign'
        put 'analytics'
        get 'orders', to: 'riders#orders'
      end
    end

    resources :conversations, only: [:index, :show, :create] do
      resources :messages, only: [:index, :create]
    end

    resources :analytics
    resources :reviews
    resources :abouts
    resources :faqs
    resources :banners
    resources :promotions, except: [:new, :edit]
    get 'identify', to: 'admins#identify'
    resources :notifications, only: [:index, :create]
    resources :ad_searches, only: [:index, :show, :destroy]
    resources :click_events, only: [:index, :show, :destroy]
    resources :tiers, only: [:index, :show, :create, :update, :destroy]
  end

  #=================================================Vendor namespace for vendor-specific functionality===============================#
  namespace :vendor do
    post 'signup', to: 'vendors#create'
    
    resources :ads
    resources :orders do
      member do
        put 'update_status', to: 'orders#update_status' # Custom route for updating order status
      end
    end

    resources :shipments
    resources :categories, only: [:index, :show]
    get 'categories', to: 'categories#index'
    get 'subcategories', to: 'subcategories#index'
    resources :analytics, only: [:index]
    resources :reviews, only: [:index, :show] do
      post 'reply', on: :member
    end

    resource :profile, only: [:show, :update] do
      post 'change-password', to: 'profiles#change_password'
    end

    resources :messages
    get 'identify', to: 'vendors#identify'
    resources :notifications

    # Vendor Tiers
    resources :vendor_tiers, only: [:index, :show] do
      patch 'update_tier', on: :collection
    end

    # Custom route for vendor_id handling
    get 'vendor_tiers/:vendor_id', to: 'vendor_tiers#show'
  end


  #==========================================Purchaser namespace for purchaser-specific functionality=========================================#
  namespace :purchaser, defaults:{ format: :json}, path: 'purchaser' do
    post 'signup', to: 'purchasers#create'

    resource :profile, only: [:show, :update] do
      post 'change-password', to: 'profiles#change_password'
    end

    resources :wish_lists, only: [:index, :create, :destroy] do
      member do
        post 'add_to_cart' # This route adds the ad to the cart
      end
    end

    resources :reviews
    resources :messages
    resources :categories
    resources :notifications
    resources :subcategories

    resources :cart_items, only: [:index, :create, :destroy, :update] do
      collection do
        post :checkout
      end
    end

    resources :buy_for_me_order_cart_items, only: [:index, :create, :destroy, :update] do
      collection do
        post :checkout
      end
    end
    
    post 'validate_coupon', to: 'promotions#validate_coupon'

    resources :ads, only: [:index, :show] do
      collection do
        get 'search'
      end
      member do
        post 'add_to_cart'
        post 'add_to_buy_for_me_order_cart'
        get 'related', to: 'ads#related'
        get 'vendor', to: 'ads#vendor'
      end
      resources :reviews, only: [:create, :index] # Nested reviews under ads
    end

    resources :orders, only: [:index, :show, :create] do
      member do
        put  :update_status_to_delivered
      end
    end

    resources :buy_for_me_orders, only: [:index, :show, :create]

    get 'identify', to: 'purchasers#identify'
  end

  #==========================================Rider namespace for purchaser-specific functionality=========================================#
  namespace :rider do
    resources :riders
    resources :orders
    post 'signup', to: 'riders#create'
  end
  #========================================== End of Rider namespace for purchaser-specific functionality=========================================#

  mount ActionCable.server => '/cable'
end
