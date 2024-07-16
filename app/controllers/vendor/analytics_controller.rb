class Vendor::AnalyticsController < ApplicationController
  before_action :authenticate_vendor

  def index
    analytics_data = {
      total_orders: calculate_total_orders,
      total_revenue: calculate_total_revenue,
      average_rating: calculate_average_rating,
      reviews: fetch_reviews
    }
    render json: analytics_data
  end

  private

  def calculate_total_orders
    current_vendor.orders.count
  end

  def calculate_total_revenue
    current_vendor.orders.joins(order_items: :product).sum('order_items.quantity * products.price')
  end

  def calculate_average_rating
    current_vendor.products.joins(:reviews).average(:rating).to_f.round(1)
  end

  def fetch_reviews
    current_vendor.reviews.includes(:product).map do |review|
      {
        id: review.id,
        product_name: review.product.title,
        rating: review.rating,
        comment: review.review
      }
    end
  end

  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def current_vendor
    @current_user
  end
end
