class Admin::Vendors::AnalyticsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_vendor

  # GET /admin/vendors/:vendor_id/analytics
  def show
    # Calculate total revenue from all orders related to the vendor's products
    total_revenue = @vendor.orders.joins(:order_items)
                              .where(order_items: { product_id: @vendor.products.pluck(:id) })
                              .sum('order_items.quantity * order_items.price')

    # Calculate total number of orders related to the vendor's products
    total_orders = @vendor.orders.joins(:order_items)
                              .where(order_items: { product_id: @vendor.products.pluck(:id) })
                              .distinct.count

    # Calculate total number of products sold (sum of quantities)
    total_products_sold = @vendor.orders.joins(:order_items)
                                  .where(order_items: { product_id: @vendor.products.pluck(:id) })
                                  .sum('order_items.quantity')

    # Calculate average rating (mean of ratings) from reviews related to the vendor's products
    mean_rating = @vendor.reviews.joins(:product)
                          .where(products: { id: @vendor.products.pluck(:id) })
                          .average(:rating).to_f

    # Count the number of reviews related to the vendor's products and group by rating
    reviews_by_rating = @vendor.reviews.joins(:product)
                                  .where(products: { id: @vendor.products.pluck(:id) })
                                  .group(:rating)
                                  .count

    # Prepare data for pie chart
    rating_pie_chart = (1..5).map do |rating|
      {
        rating: rating,
        count: reviews_by_rating[rating] || 0
      }
    end

    # Fetch detailed reviews with purchaser information
    reviews_details = @vendor.reviews.joins(:product, :purchaser)
                              .where(products: { id: @vendor.products.pluck(:id) })
                              .select('reviews.*, purchasers.fullname AS purchaser_name')
                              .as_json(only: [:id, :rating, :review, :created_at],
                                        include: { purchaser: { only: [:fullname] } })

    # Prepare the analytics response
    analytics = {
      total_revenue: total_revenue,
      total_orders: total_orders,
      total_products_sold: total_products_sold,
      mean_rating: mean_rating,
      total_reviews: reviews_by_rating.values.sum,
      rating_pie_chart: rating_pie_chart,
      reviews: reviews_details
    }

    render json: analytics
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:vendor_id])
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Admin)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
end
