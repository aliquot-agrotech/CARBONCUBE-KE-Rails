class Vendor::AnalyticsController < ApplicationController
  before_action :authenticate_vendor

  def index
    total_orders = current_vendor.orders.count
    total_revenue = calculate_total_revenue
    average_rating = calculate_average_rating

    analytics_data = {
      total_orders: total_orders,
      total_revenue: total_revenue,
      average_rating: average_rating
    }

    render json: analytics_data
  end

  private

  def authenticate_vendor
    @current_user = AuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def current_vendor
    @current_user
  end

  def calculate_total_revenue
    # Assuming 'OrderItem' model has 'quantity' and 'product' association with 'price'
    current_vendor.orders.joins(order_items: :product).sum('order_items.quantity * products.price')
  end

  def calculate_average_rating
    # Assuming 'Review' model has 'rating' attribute and 'Product' model has 'vendor' association
    reviews = Review.joins(product: :vendor).where(vendors: { id: current_vendor.id })
    total_reviews = reviews.count
    total_ratings_sum = reviews.sum(:rating)
    average_rating = total_reviews > 0 ? total_ratings_sum.to_f / total_reviews : 0
    average_rating.round(2)
  end
end
