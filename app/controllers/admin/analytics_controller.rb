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

#=============================================================PURCHASER INSIGHTS=============================================================#

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

#=============================================================VENDOR INSIGHTS=============================================================#

    # Get selected metric from query parameter, default to 'Rating' if none provided
    selected_metric = params[:metric] || 'Rating'

    # Calculate vendor mean rating
    vendors_by_rating = Vendor.joins(ads: :reviews)
                        .select('vendors.id, vendors.fullname, COALESCE(AVG(reviews.rating), 0) AS mean_rating')
                        .group('vendors.id')
                        .order('mean_rating DESC')

    # Calculate vendor total ads
    vendors_by_ads = Vendor.joins(:ads)
                        .select('vendors.id, vendors.fullname, COUNT(ads.id) AS total_ads')
                        .group('vendors.id')
                        .order('total_ads DESC')

    # Calculate vendor total reveal clicks
    vendors_by_reveal_clicks = Vendor.joins(ads: :click_events)
                        .where(click_events: { event_type: 'Reveal-Vendor-Details' })
                        .select('vendors.id, vendors.fullname, COUNT(click_events.id) AS reveal_clicks')
                        .group('vendors.id')
                        .order('reveal_clicks DESC')

    # Calculate vendor total ad clicks
    vendors_by_ad_clicks = Vendor.joins(ads: :click_events)
                        .where(click_events: { event_type: 'Ad-Click' })
                        .select('vendors.id, vendors.fullname, COUNT(click_events.id) AS total_ad_clicks')
                        .group('vendors.id')
                        .order('total_ad_clicks DESC')

    # Dynamically select the vendors' insights based on the metric
    vendors_insights = case selected_metric
      when 'Rating' then vendors_by_rating
      when 'Total Ads' then vendors_by_ads
      when 'Reveal Clicks' then vendors_by_reveal_clicks
      when 'Ad Clicks' then vendors_by_ad_clicks
      else vendors_by_rating
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

#===============================================================CATEGORY ANALYTICS===============================================================#

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
    # Rails.logger.info "Fetched Category Click Event Data: #{category_click_events.inspect}"
    # 
    category_wishlists = Category
      .joins(ads: :wish_lists)
      .select('categories.id, categories.name, COUNT(wish_lists.id) AS total_wishlists')
      .group('categories.id, categories.name')
      .order('total_wishlists DESC')

    # Get total wishlists across all categories
    total_wishlists = category_wishlists.sum(&:total_wishlists)

    # Calculate percentage of wishlists per category
    category_wishlist_data = category_wishlists.map do |category|
      {
        category_id: category.id,
        category_name: category.name,
        total_wishlists: category.total_wishlists,
        wishlist_percentage: total_wishlists.zero? ? 0 : ((category.total_wishlists.to_f / total_wishlists) * 100).round(2)
      }
    end

    # Log the data for tracking purposes
    # Rails.logger.info "Fetched Category Wishlist Data: #{category_wishlist_data.inspect}"

    # Total number of orders by status
    statuses = ['Processing', 'Dispatched', 'In-Transit', 'Delivered', 'Cancelled', 'Returned']
    order_counts_by_status = statuses.map do |status|
      { name: status, count: Order.where(status: status).count }
    end

#===============================================================PURCHASER ANALYTICS===============================================================#

    # Calculate Age Groups
    age_groups = {
      '18-24' => 0, '25-34' => 0, '35-44' => 0, '45-54' => 0, '55+' => 0
    }

    Purchaser.find_each do |purchaser|
      # Check for valid birthdate format and ensure it's a Date object
      if purchaser.birthdate.present?
        # Ensure the birthdate is a Date object
        begin
          birthdate = purchaser.birthdate.to_date
          age = ((Time.zone.today - birthdate) / 365).to_i

          # Handle age group assignment
          case age
          when 18..24 then age_groups['18-24'] += 1
          when 25..34 then age_groups['25-34'] += 1
          when 35..44 then age_groups['35-44'] += 1
          when 45..54 then age_groups['45-54'] += 1
          else age_groups['55+'] += 1 if age && age >= 55
          end
        rescue StandardError => e
          Rails.logger.error "Error processing purchaser #{purchaser.id}: #{e.message}"
        end
      else
        Rails.logger.warn "Purchaser #{purchaser.id} has an invalid or missing birthdate"
      end
    end

    # Gender Distribution
    gender_distribution = Purchaser.group(:gender).count

    # Employment Breakdown
    employment_data = Employment.joins(:purchasers)
                                      .select('employments.status, COUNT(purchasers.id) AS total')
                                      .group('employments.status')

    # Income Distribution
    income_data = Income.joins(:purchasers)
                            .select('incomes.range, COUNT(purchasers.id) AS total')
                            .group('incomes.range')

    # Education Breakdown
    education_data = Education.joins(:purchasers)
                                  .select('educations.level, COUNT(purchasers.id) AS total')
                                  .group('educations.level')

    # Sector Breakdown
    sector_data = Sector.joins(:purchasers)
                        .select('sectors.name, COUNT(purchasers.id) AS total')
                        .group('sectors.name')

    # Location Distribution
    # location_distribution = Purchaser.group(:location).count

    # Log all purchaser insights in one entry
    Rails.logger.info "Age Groups: #{age_groups}"
    Rails.logger.info "Gender Distribution: #{gender_distribution}"
    Rails.logger.info "Employment Data: #{employment_data.map { |e| { e.status => e.total } }}"
    Rails.logger.info "Income Data: #{income_data.map { |i| { i.range => i.total } }}"
    Rails.logger.info "Education Data: #{education_data.map { |e| { e.level => e.total } }}"
    Rails.logger.info "Sector Data: #{sector_data.map { |s| { s.name => s.total } }}"
    # Rails.logger.info "Location Distribution: #{location_distribution}"

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
      category_click_events: category_click_events,
      category_wishlist_data: category_wishlist_data,
      age_groups: age_groups,
      gender_distribution: gender_distribution,
      employment_data: employment_data,
      income_data: income_data,
      education_data: education_data,
      sector_data: sector_data
      # location_distribution: location_distribution
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
