class Admin::AnalyticsController < ApplicationController
  before_action :authenticate_admin

  def index
    @total_vendors = Vendor.count
    @total_purchasers = Purchaser.count
    @total_orders = Order.count
    @total_ads = Ad.count
    @total_reviews = Review.count

    # Top 6 Best Selling Ads Overall
    best_selling_ads = Ad.joins(:order_items)
                            .select('ads.id AS ad_id, ads.title AS ad_title, ads.price AS ad_price, SUM(order_items.quantity) AS total_sold, ads.media AS media')
                            .group('ads.id')
                            .order('total_sold DESC')
                            .limit(6)
                            .map { |record| 
                              {
                                ad_id: record.ad_id,
                                ad_title: record.ad_title,
                                ad_price: record.ad_price,
                                total_sold: record.total_sold,
                                media: record.media
                              }
                            }

    # Total Ads Wish-Listed
    total_ads_wish_listed = WishList.count


    # Get selected metric from query parameter, default to 'Total Orders' if none provided
    selected_metric = params[:metric] || 'Total Orders'

    # Calculate purchaser total orders
    purchasers_by_orders = Purchaser.joins(:orders)
                          .select('purchasers.id AS purchaser_id, purchasers.fullname, COUNT(orders.id) AS total_orders')
                          .group('purchasers.id')
                          .order('total_orders DESC')

    # Calculate purchaser total expenditure
    purchasers_by_expenditure = Purchaser.joins(:orders)
                                .select('purchasers.id AS purchaser_id, purchasers.fullname, SUM(orders.total_amount) AS total_expenditure')
                                .group('purchasers.id')
                                .order('total_expenditure DESC')

    # Dynamically select the purchasers' insights based on the metric
    purchasers_insights = case selected_metric
      when 'Total Orders' then purchasers_by_orders
      when 'Total Expenditure' then purchasers_by_expenditure
      else purchasers_by_orders
    end.limit(10)

    # Get selected metric from query parameter, default to 'Total Orders' if none provided
    selected_metric = params[:metric] || 'Total Orders'

    # Calculate vendor total orders
    vendors_by_orders = Vendor.joins(orders: :order_items)
                        .select( 'vendors.id AS vendor_id, vendors.fullname, COUNT(DISTINCT orders.id) AS total_orders') 
                        .group('vendors.id')
                        .order('total_orders DESC')

    # Calculate vendor total revenue
    vendors_by_revenue = Vendor.joins(ads: :order_items)
                        .select('vendors.id, vendors.fullname, SUM(order_items.total_price) AS total_revenue')
                        .group('vendors.id')
                        .order('total_revenue DESC')

    # Calculate vendor mean rating
    vendors_by_rating = Vendor.joins(ads: :reviews)
                        .select('vendors.id, vendors.fullname, COALESCE(AVG(reviews.rating), 0) AS mean_rating')
                        .group('vendors.id')
                        .order('mean_rating DESC')

    # Dynamically select the vendors' insights based on the metric
    vendors_insights = case selected_metric
      when 'Total Orders' then vendors_by_orders
      when 'Total Revenue' then vendors_by_revenue
      when 'Rating' then vendors_by_rating
      else vendors_by_revenue
    end.limit(10)


    # Total Revenue
    total_revenue = Order.sum(:total_amount)

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
    best_selling_categories = Category.joins(ads: :order_items)
                              .select('categories.name AS category_name, SUM(order_items.quantity) AS total_sold')
                              .group('categories.id')
                              .order('total_sold DESC')
                              .limit(4)
                              .map { |record| { category_name: record.category_name, total_sold: record.total_sold } }

    # Total number of orders by status
    statuses = ['Processing', 'Dispatched', 'In-Transit', 'Delivered', 'Cancelled', 'Returned']
    order_counts_by_status = statuses.map do |status|
      { name: status, count: Order.where(status: status).count }
    end



    render json: {
      total_vendors: @total_vendors,
      total_purchasers: @total_purchasers,
      total_orders: @total_orders,
      total_ads: @total_ads,
      total_reviews: @total_reviews,
      best_selling_ads: best_selling_ads,
      total_ads_wish_listed: total_ads_wish_listed,
      purchasers_insights: purchasers_insights,
      vendors_insights: vendors_insights,
      total_revenue: total_revenue,
      sales_performance: sales_performance,
      best_selling_categories: best_selling_categories,
      order_counts_by_status: order_counts_by_status
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
