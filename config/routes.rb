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
    post 'signup', to: 'vendors#create'
    resources :products
    resources :orders do
      member do
        put 'on-transit', to: 'orders#update_status_to_on_transit'
      end
    end
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
    
    resources :purchasers, only: [:show, :update]
    resources :bookmarks, only: [:create, :destroy]   
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
  end
end
