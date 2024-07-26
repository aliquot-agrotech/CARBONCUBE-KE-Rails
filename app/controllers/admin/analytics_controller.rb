class Admin::AnalyticsController < ApplicationController
  before_action :authenticate_admin

  def index
    @total_vendors = Vendor.count
    @total_purchasers = Purchaser.count
    @total_orders = Order.count
    @total_products = Product.count
    @total_reviews = Review.count

    # Best Selling Product for Each Category
    best_selling_products = Product.joins(:order_items)
                                   .select('products.*, categories.name as category_name, SUM(order_items.quantity) AS total_sold')
                                   .joins(:category)
                                   .group('products.id, categories.id')
                                   .order('total_sold DESC')
                                   .group_by(&:category_id)
                                   .map { |category_id, products| products.first }

    # Total Products Sold Out
    total_products_sold_out = OrderItem.distinct.count(:product_id)

    # Top 5 Purchasers Insights
    purchasers_insights = Purchaser.joins(:orders)
                                   .select('purchasers.fullname, COUNT(orders.id) AS total_orders')
                                   .group('purchasers.id')
                                   .order('total_orders DESC')
                                   .limit(5)

    # Total Revenue
    total_revenue = Order.joins(:order_items)
                         .sum('order_items.price * order_items.quantity')

    # Sales Performance (example: revenue by month)
    sales_performance = Order.joins(:order_items)
                             .group("DATE_TRUNC('month', orders.created_at)")
                             .sum('order_items.price * order_items.quantity')

    render json: {
      total_vendors: @total_vendors,
      total_purchasers: @total_purchasers,
      total_orders: @total_orders,
      total_products: @total_products,
      total_reviews: @total_reviews,
      best_selling_products: best_selling_products,
      total_products_sold_out: total_products_sold_out,
      purchasers_insights: purchasers_insights,
      total_revenue: total_revenue,
      sales_performance: sales_performance
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
