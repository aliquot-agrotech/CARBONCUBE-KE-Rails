class Admin::AnalyticsController < ApplicationController
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
  end
  