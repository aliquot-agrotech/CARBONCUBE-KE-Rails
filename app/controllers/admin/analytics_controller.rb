class Admin::AnalyticsController < ApplicationController
  before_action :authenticate_admin
    def index
      @total_vendors = Vendor.count
      @total_purchasers = Purchaser.count
      @total_orders = Order.count
      @total_products = Product.count
      @total_reviews = Review.count
  
      render json: {
        total_vendors: @total_vendors,
        total_purchasers: @total_purchasers,
        total_orders: @total_orders,
        total_products: @total_products,
        total_reviews: @total_reviews
      }
    end

    private

    def authenticate_admin
      @current_user = AdminAuthorizeApiRequest.new(request.headers).result
      unless @current_user && @current_user.is_a?(Admin)
        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
  
    def current_admin
      @current_user
    end
  end
  