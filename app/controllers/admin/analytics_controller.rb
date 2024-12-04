class Admin::AnalyticsController < ApplicationController
  before_action :authenticate_admin

  def index
    @total_vendors = Vendor.count
    @total_purchasers = Purchaser.count
    @total_orders = Order.count
    @total_products = Product.count
    @total_reviews = Review.count

    # Top 6 Best Selling Products Overall
    best_selling_products = Product.joins(:order_items)
                                  .select('products.id AS product_id, products.title AS product_title, products.price AS product_price, SUM(order_items.quantity) AS total_sold, products.media AS media')
                                  .group('products.id')
                                  .order('total_sold DESC')
                                  .limit(6)
                                  .map { |record| 
                                    {
                                      product_id: record.product_id,
                                      product_title: record.product_title,
                                      product_price: record.product_price,
                                      total_sold: record.total_sold,
                                      media: record.media
                                    }
                                  }

    # Total Products Sold Out
    total_products_sold_out = Product.joins(:order_items)
                                    .distinct
                                    .count

    # Top 10 Purchasers Insights
    purchasers_insights = Purchaser.joins(:orders)
                                  .select('purchasers.fullname, COUNT(orders.id) AS total_orders')
                                  .group('purchasers.id')
                                  .order('total_orders DESC')
                                  .limit(10)

    # Get selected metric from query parameter, default to 'Total Orders' if none provided
    selected_metric = params[:metric] || 'Total Orders'

    # Calculate total orders
    vendors_by_orders = Vendor.joins(orders: :order_items)
                              .select(
                                'vendors.id AS vendor_id',
                                'vendors.fullname',
                                'COUNT(DISTINCT orders.id) AS total_orders'
                              )
                              .group('vendors.id')
                              .order('total_orders DESC')

    # Calculate total revenue
    # vendors_by_revenue = Vendor.joins(orders: :order_items)
    #                           .joins(products: :order_items)
    #                           .select(
    #                             'vendors.id AS vendor_id',
    #                             'vendors.fullname',
    #                             'SUM(order_items.quantity * order_items.price) AS total_revenue'
    #                           )
    #                           .group('vendors.id')
    #                           .order('total_revenue DESC')

    vendors_by_revenue = Vendor.joins(products: :order_items)
    .select('vendors.id, vendors.fullname, SUM(order_items.total_price) AS total_revenue')
    .group('vendors.id')
    .order('total_revenue DESC')


    # Calculate mean rating
    vendors_by_rating = Vendor.joins(products: :reviews)
                              .select(
                                'vendors.id AS vendor_id',
                                'vendors.fullname',
                                'AVG(COALESCE(reviews.rating, 0)) AS mean_rating'
                              )
                              .group('vendors.id')
                              .order('mean_rating DESC')

    # Dynamically select the vendors' insights based on the metric
    case selected_metric
      when 'Total Orders'
        vendors_insights = vendors_by_orders
      when 'Total Revenue'
        vendors_insights = vendors_by_revenue
      when 'Rating'
        vendors_insights = vendors_by_rating
      else
        vendors_insights = vendors_by_revenue # Default to Total Orders
    end

    # Limit the results to the top 10
    vendors_insights = vendors_insights.limit(10)

    # Total Revenue
    total_revenue = Order.joins(:order_items).sum('order_items.price * order_items.quantity')

    # Sales Performance (example: revenue by month)
    # Sales Performance for the last 3 months
    current_month = Date.current.beginning_of_month
    three_months_ago = 2.months.ago.beginning_of_month

    sales_performance = Order.joins(:order_items)
                            .where(created_at: three_months_ago..current_month.end_of_month)
                            .group("DATE_TRUNC('month', orders.created_at)")
                            .sum('order_items.price * order_items.quantity')
                            .transform_keys { |k| k.strftime("%B %Y") }

    # Best Selling Categories Analytics
    best_selling_categories = Category.joins(products: :order_items)
                                      .select('categories.name AS category_name, SUM(order_items.quantity) AS total_sold')
                                      .group('categories.id')
                                      .order('total_sold DESC')
                                      .limit(4)
                                      .map { |record| { category_name: record.category_name, total_sold: record.total_sold } }

    render json: {
      total_vendors: @total_vendors,
      total_purchasers: @total_purchasers,
      total_orders: @total_orders,
      total_products: @total_products,
      total_reviews: @total_reviews,
      best_selling_products: best_selling_products,
      total_products_sold_out: total_products_sold_out,
      purchasers_insights: purchasers_insights,
      vendors_insights: vendors_insights,
      total_revenue: total_revenue,
      sales_performance: sales_performance,
      best_selling_categories: best_selling_categories
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
