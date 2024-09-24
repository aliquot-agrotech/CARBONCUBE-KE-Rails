class Vendor::AnalyticsController < ApplicationController
  before_action :authenticate_vendor

  def index
    render json: {
      total_orders: calculate_total_orders,
      total_revenue: calculate_total_revenue,
      total_products: calculate_total_products,
      average_rating: calculate_average_rating,
      total_reviews: calculate_total_reviews,
      sales_performance: calculate_sales_performance,
      best_selling_products: fetch_best_selling_products
    }
  end

  private

  def calculate_total_orders
    current_vendor.orders.count
  end

  def calculate_total_revenue
    current_vendor.orders.joins(order_items: :product).sum('order_items.quantity * products.price')
  end

  def calculate_total_products
    current_vendor.products.count
  end

  def calculate_average_rating
    current_vendor.products.joins(:reviews).average(:rating).to_f.round(1)
  end

  def calculate_total_reviews
    current_vendor.reviews.count
  end

  def calculate_sales_performance
    current_month = Date.current.beginning_of_month
    three_months_ago = 3.months.ago.beginning_of_month
  
    sales_performance = current_vendor.orders.joins(:order_items)
                             .where(created_at: three_months_ago..current_month.end_of_month)
                             .group("DATE_TRUNC('month', orders.created_at)")
                             .sum('order_items.quantity * order_items.price')
                             .transform_keys { |k| k.strftime("%B %Y") }
  
    sales_performance
  end
  

  def fetch_best_selling_products
    best_selling_products = current_vendor.products.joins(:order_items)
                                  .select('products.id AS product_id, products.title AS product_title, products.price AS product_price, SUM(order_items.quantity) AS total_sold, products.media AS media')
                                  .group('products.id')
                                  .order('total_sold DESC')
                                  .limit(3)
                                  .map { |record| 
                                    {
                                      product_id: record.product_id,
                                      product_title: record.product_title,
                                      product_price: record.product_price,
                                      total_sold: record.total_sold,
                                      media: record.media # Add media here
                                    }
                                  }
  
    best_selling_products
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
