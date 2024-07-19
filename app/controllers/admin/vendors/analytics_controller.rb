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

    # Count the number of reviews related to the vendor's products
    total_reviews = @vendor.reviews.joins(:product)
                              .where(products: { id: @vendor.products.pluck(:id) })
                              .count

    # Fetch detailed reviews with purchaser information and product title
    reviews_details = @vendor.reviews.joins(:product, :purchaser)
                               .where(products: { id: @vendor.products.pluck(:id) })
                               .select('reviews.id, reviews.rating, reviews.review, reviews.created_at, purchasers.fullname AS purchaser_name, products.title AS product_title')
                               .as_json(only: [:id, :rating, :review, :created_at],
                                        methods: [:purchaser_name, :product_title])

    # Prepare the analytics response
    analytics = {
      total_revenue: total_revenue,
      total_orders: total_orders,
      total_products_sold: total_products_sold,
      mean_rating: mean_rating,
      total_reviews: total_reviews,
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
