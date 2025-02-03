class Admin::AnalyticsController < ApplicationController
  before_action :authenticate_admin

  def index
    @total_vendors = Vendor.count
    @total_purchasers = Purchaser.count
    @total_ads = Ad.count
    @total_reviews = Review.count

    # Top 6 Most Wish-Listed Ads Overall
    top_wishlisted_ads = Ad.joins(:wish_lists)
                        .select('ads.id AS ad_id, ads.title AS ad_title, ads.price AS ad_price, COUNT(wish_lists.id) AS wishlist_count, ads.media AS media')
                        .group('ads.id')
                        .order('wishlist_count DESC')
                        .limit(6)
                        .map { |record| 
                          {
                            ad_id: record.ad_id,
                            ad_title: record.ad_title,
                            ad_price: record.ad_price,
                            wishlist_count: record.wishlist_count,
                            media: record.media
                          }
                        }

    # Total Ads Wish-Listed
    total_ads_wish_listed = WishList.count


    # Get selected metric from query parameter, default to 'Total Click Events' if none provided
    selected_metric = params[:metric] || 'Total Wishlists'

    # Calculate purchaser total wishlists
    purchasers_by_wishlists = Purchaser.joins(:wish_lists)
                              .select('purchasers.id AS purchaser_id, purchasers.fullname, COUNT(wish_lists.id) AS total_wishlists')
                              .group('purchasers.id')
                              .order('total_wishlists DESC')

    # Calculate purchaser total click events (sum of all click types)
    purchasers_by_clicks = Purchaser.joins(:click_events)
                              .select('purchasers.id AS purchaser_id, purchasers.fullname, COUNT(click_events.id) AS total_clicks')
                              .group('purchasers.id')
                              .order('total_clicks DESC')

    # Dynamically select the purchasers' insights based on the metric
    purchasers_insights = case selected_metric
      when 'Total Wishlists' then purchasers_by_wishlists
      when 'Total Click Events' then purchasers_by_clicks
      else purchasers_by_clicks
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


    # # Total Revenue
    # total_revenue = Order.sum(:total_amount)

    # Sales Performance (example: revenue by month)
    # Sales Performance for the last 3 months
    current_month = Date.current.beginning_of_month
    three_months_ago = 2.months.ago.beginning_of_month

    sales_performance = Order.joins(:order_items)
                        .where(created_at: three_months_ago..current_month.end_of_month)
                        .group("DATE_TRUNC('month', orders.created_at)")
                        .sum('order_items.price * order_items.quantity')
                        .transform_keys { |k| k.strftime("%B %Y") }

    # Count the number of ads for each category
    ads_per_category = Category.joins(:ads)
                      .select('categories.name AS category_name, COUNT(ads.id) AS total_ads')
                      .group('categories.id')
                      .order('total_ads DESC')
                      .limit(4)
                      .map { |record| { category_name: record.category_name, total_ads: record.total_ads } }

    # Log the result of the query
    # Rails.logger.info "Fetched Top 4 Categories by Ad Count: #{ads_per_category.inspect}"

    # # Log if no data was fetched
    # if ads_per_category.empty?
    # Rails.logger.warn "No ads found for any categories."
    # end

    #Count of Click Events for each category
    category_click_events = Category.joins(ads: :click_events)
                            .select('categories.name AS category_name, 
                                    SUM(CASE WHEN click_events.event_type = \'Ad-Click\' THEN 1 ELSE 0 END) AS ad_clicks,
                                    SUM(CASE WHEN click_events.event_type = \'Add-to-Wish-List\' THEN 1 ELSE 0 END) AS wish_list_clicks,
                                    SUM(CASE WHEN click_events.event_type = \'Reveal-Vendor-Details\' THEN 1 ELSE 0 END) AS reveal_clicks')
                            .group('categories.id')
                            .order('category_name')
                            .map { |record| 
                              {
                                category_name: record.category_name,
                                ad_clicks: record.ad_clicks,
                                wish_list_clicks: record.wish_list_clicks,
                                reveal_clicks: record.reveal_clicks
                              }
                            }

    # Log the data for tracking purposes
    Rails.logger.info "Fetched Category Click Event Data: #{category_click_events.inspect}"

    # Total number of orders by status
    statuses = ['Processing', 'Dispatched', 'In-Transit', 'Delivered', 'Cancelled', 'Returned']
    order_counts_by_status = statuses.map do |status|
      { name: status, count: Order.where(status: status).count }
    end



    render json: {
      total_vendors: @total_vendors,
      total_purchasers: @total_purchasers,
      total_ads: @total_ads,
      total_reviews: @total_reviews,
      top_wishlisted_ads: top_wishlisted_ads,
      total_ads_wish_listed: total_ads_wish_listed,
      purchasers_insights: purchasers_insights,
      vendors_insights: vendors_insights,
      sales_performance: sales_performance,
      ads_per_category: ads_per_category,
      order_counts_by_status: order_counts_by_status,
      category_click_events: category_click_events
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
