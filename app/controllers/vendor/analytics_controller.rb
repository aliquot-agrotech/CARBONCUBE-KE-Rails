class Vendor::AnalyticsController < ApplicationController
  before_action :authenticate_vendor

  def index
    # Get vendor's tier_id
    tier_id = current_vendor.vendor_tier&.tier_id


    # Prepare the response based on the vendor's tier
    response_data = {
      tier_id: tier_id, # Include tier_id in the response
      total_orders: calculate_total_orders,
      total_ads: calculate_total_ads
    }

    # Add more data based on the vendor's tier
    case tier_id
    when 1 # Free tier
      response_data.merge!(calculate_free_tier_data)
    when 2 # Basic tier
      response_data.merge!(calculate_basic_tier_data)
    when 3 # Standard tier
      response_data.merge!(calculate_standard_tier_data)
      response_data.merge!(click_events_stats: calculate_click_events_stats)
    when 4 # Premium tier
      response_data.merge!(calculate_premium_tier_data)
      response_data.merge!(
        wishlist_stats: top_wishlist_stats,
        competitor_stats: calculate_competitor_stats,
        click_events_stats: calculate_click_events_stats
      )
    else
      render json: { error: 'Invalid tier' }, status: 400
      return
    end

    render json: response_data
  end





  private





  # Data for Free tier
  def calculate_free_tier_data
    {
      total_orders: calculate_total_orders,
      total_ads: calculate_total_ads,
      average_rating: calculate_average_rating
    }
  end

  # Data for Basic tier
  def calculate_basic_tier_data
    {
      total_revenue: calculate_total_revenue
    }
  end

  # Data for Standard tier
  def calculate_standard_tier_data
    {
      total_revenue: calculate_total_revenue,
      total_reviews: calculate_total_reviews,
      sales_performance: calculate_sales_performance,
      best_selling_ads: fetch_best_selling_ads
    }
  end

  # Data for Premium tier
  def calculate_premium_tier_data
    {
      total_revenue: calculate_total_revenue,
      average_rating: calculate_average_rating,
      total_reviews: calculate_total_reviews,
      sales_performance: calculate_sales_performance,
      best_selling_ads: fetch_best_selling_ads,
      wishlist_stats: top_wishlist_stats, # Merge wishlist stats into the response
      click_events_stats: calculate_click_events_stats
    }
  end

  #==========================================================

  # Combined method to return all top groups
  # def top_wishlist_stats
  #   {
  #     top_age_group: top_age_group,
  #     top_income_range: top_income_range,
  #     top_education_level: top_education_level,
  #     top_employment_status: top_employment_status,
  #     top_sector: top_sector,
  #     wishlist_trends: wishlist_trends,
  #     top_wishlisted_products: top_wishlisted_products,
  #   }
  # end

  # Combined method to return all top groups with logging
def top_wishlist_stats
  stats = {
    top_age_group: top_age_group,
    top_income_range: top_income_range,
    top_education_level: top_education_level,
    top_employment_status: top_employment_status,
    top_sector: top_sector,
    wishlist_trends: wishlist_trends,
    top_wishlisted_products: top_wishlisted_products,
  }

  Rails.logger.info "Final Wishlist Stats: #{stats}"
  stats
end

  # Calculate CLICK EVENTS STATS
  def calculate_click_events_stats
    {
      age_groups: group_clicks_by_age,
      income_ranges: group_clicks_by_income,
      education_levels: group_clicks_by_education,
      employment_statuses: group_clicks_by_employment,
      sectors: group_clicks_by_sector
    }
  end





  #================================================= CLICK EVENTS PURCHASER DEMOGRAPHICS =================================================#

  # Group clicks by age groups
  def group_clicks_by_age
    ClickEvent.includes(:purchaser, :ad)
      .where(ads: { vendor_id: current_vendor.id })
      .group("FLOOR(DATE_PART('year', AGE(purchasers.birthdate)) / 5) * 5", :event_type)
      .count
      .transform_keys do |k|
        {
          age_group: "#{k[0]}–#{k[0].to_i + 4}",
          event_type: k[1]
        }
      end
  end  

  # Group clicks by income ranges
  def group_clicks_by_income
    ClickEvent.joins(ad: {}, purchaser: :income)
              .where(ads: { vendor_id: current_vendor.id })
              .group("incomes.range", :event_type)
              .count
              .transform_keys { |k| { income_range: k[0], event_type: k[1] } }
  end

  # Group clicks by education levels
  def group_clicks_by_education
    ClickEvent.joins(ad: {}, purchaser: :education)
              .where(ads: { vendor_id: current_vendor.id })
              .group("educations.level", :event_type)
              .count
              .transform_keys { |k| { education_level: k[0], event_type: k[1] } }
  end

  # Group clicks by employment statuses
  def group_clicks_by_employment
    ClickEvent.joins(ad: {}, purchaser: :employment)
              .where(ads: { vendor_id: current_vendor.id })
              .group("employments.status", :event_type)
              .count
              .transform_keys { |k| { employment_status: k[0], event_type: k[1] } }
  end

  # Group clicks by sectors
  def group_clicks_by_sector
    ClickEvent.joins(ad: {}, purchaser: :sector)
              .where(ads: { vendor_id: current_vendor.id })
              .group("sectors.name", :event_type)
              .count
              .transform_keys { |k| { sector: k[0], event_type: k[1] } }
  end




#================================================= WISHLISTS PURCHASER DEMOGRAPHICS =================================================#
  # Get the age group with the highest wishlists
def top_age_group
  data = WishList.joins("INNER JOIN purchasers ON wish_lists.purchaser_id = purchasers.id")
                 .joins("INNER JOIN ads ON wish_lists.ad_id = ads.id")
                 .where(ads: { vendor_id: current_vendor.id })
                 .group("FLOOR(DATE_PART('year', AGE(purchasers.birthdate)) / 5) * 5")
                 .count
  
  Rails.logger.info "Age Group Wishlist Distribution: #{data}"

  group = data.max_by { |_, count| count }

  result = group ? { age_group: "#{group[0]}–#{group[0] + 4}", wishlists: group[1] } : nil
  Rails.logger.info "Top Age Group: #{result}"
  
  result
end

# Get the income range with the highest wishlists
def top_income_range
  data = WishList.joins(:ad, purchaser: :income)
                 .joins("INNER JOIN ads ON wish_lists.ad_id = ads.id")
                 .where(ads: { vendor_id: current_vendor.id })
                 .group("incomes.range")
                 .count
  
  Rails.logger.info "Income Range Wishlist Distribution: #{data}"

  group = data.max_by { |_, count| count }

  result = group ? { income_range: group[0], wishlists: group[1] } : nil
  Rails.logger.info "Top Income Range: #{result}"
  
  result
end

# Get the education level with the highest wishlists
def top_education_level
  data = WishList.joins(:ad, purchaser: :education)
                 .joins("INNER JOIN ads ON wish_lists.ad_id = ads.id")
                 .where(ads: { vendor_id: current_vendor.id })
                 .group("educations.level")
                 .count

  Rails.logger.info "Education Level Wishlist Distribution: #{data}"

  group = data.max_by { |_, count| count }

  result = group ? { education_level: group[0], wishlists: group[1] } : nil
  Rails.logger.info "Top Education Level: #{result}"
  
  result
end

# Get the employment status with the highest wishlists
def top_employment_status
  data = WishList.joins(:ad, purchaser: :employment)
                 .joins("INNER JOIN ads ON wish_lists.ad_id = ads.id")
                 .where(ads: { vendor_id: current_vendor.id })
                 .group("employments.status")
                 .count

  Rails.logger.info "Employment Status Wishlist Distribution: #{data}"

  group = data.max_by { |_, count| count }

  result = group ? { employment_status: group[0], wishlists: group[1] } : nil
  Rails.logger.info "Top Employment Status: #{result}"
  
  result
end

# Get the sector with the highest wishlists
def top_sector
  data = WishList.joins(:ad, purchaser: :sector)
                 .joins("INNER JOIN ads ON wish_lists.ad_id = ads.id")
                 .where(ads: { vendor_id: current_vendor.id })
                 .group("sectors.name")
                 .count

  Rails.logger.info "Sector Wishlist Distribution: #{data}"

  group = data.max_by { |_, count| count }

  result = group ? { sector: group[0], wishlists: group[1] } : nil
  Rails.logger.info "Top Sector: #{result}"
  
  result
end


  def top_wishlisted_products
    WishList.joins(:ad)
            .where(ads: { vendor_id: current_vendor.id })
            .group('ads.id', 'ads.title')  # Add 'ads.title' to the GROUP BY clause
            .select('ads.title AS ad_title, COUNT(wish_lists.id) AS wishlist_count')
            .order('wishlist_count DESC')
            .limit(3)
            .map { |record| { ad_title: record.ad_title, wishlist_count: record.wishlist_count } }
  end   

  def wishlist_trends
    # Define the date range: the current month and the previous 4 months
    end_date = Date.today.end_of_month
    start_date = (end_date - 4.months).beginning_of_month
  
    # Step 1: Find all ad IDs that belong to the current vendor
    ad_ids = Ad.where(vendor_id: current_vendor.id).pluck(:id)
    Rails.logger.info("Ad IDs for Vendor #{current_vendor.id}: #{ad_ids.inspect}")
  
    if ad_ids.empty?
      Rails.logger.warn("No Ads found for Vendor #{current_vendor.id}")
      return (0..4).map do |i|
        month_date = end_date - i.months
        {
          month: month_date.strftime('%B %Y'),
          wishlist_count: 0
        }
      end.reverse
    end
  
    # Step 2: Query the wishlists for those ads within the date range
    wishlist_counts = WishList.where(ad_id: ad_ids)
                              .where('created_at BETWEEN ? AND ?', start_date, end_date)
                              .group("DATE_TRUNC('month', created_at)")
                              .count
    Rails.logger.info("Wishlist Counts Grouped by Month: #{wishlist_counts.inspect}")
  
    # Step 3: Build the monthly data for the past 5 months
    monthly_wishlist_counts = (0..4).map do |i|
      month_date = (end_date - i.months).beginning_of_month
      wishlist_count = wishlist_counts.find { |key, _| key.to_date == month_date.to_date }&.last || 0
  
      {
        month: month_date.strftime('%B %Y'), # Format: "Month Year"
        wishlist_count: wishlist_count
      }
    end.reverse
  
    # Debugging output
    Rails.logger.info("Wishlist Trends for Vendor #{current_vendor.id}: #{monthly_wishlist_counts.inspect}")
  
    # Return the result for the frontend
    monthly_wishlist_counts
  end



  #================================================= COMPETITOR STATS =================================================#
  # Competitor Stats
  def calculate_competitor_stats
    category_id = current_vendor.ads.select(:category_id).distinct.pluck(:category_id).first
    return [] unless category_id

    {
      revenue_share: calculate_revenue_share(category_id),
      top_competitor_ads: fetch_top_competitor_ads(category_id),
      competitor_average_price: calculate_competitor_average_price(category_id)
    }
  end

  def calculate_revenue_share(category_id)
    total_category_revenue = Vendor.joins(ads: { order_items: :order })
                                    .where(ads: { category_id: category_id })
                                    .sum('order_items.quantity * ads.price')
    vendor_revenue = calculate_total_revenue

    { vendor_revenue: vendor_revenue, total_category_revenue: total_category_revenue, revenue_share: ((vendor_revenue / total_category_revenue.to_f) * 100).round(2) }
  end

  def fetch_top_competitor_ads(category_id)
    Vendor.joins(ads: { order_items: :order })
          .where(ads: { category_id: category_id })
          .where.not(id: current_vendor.id)
          .select('ads.id AS ad_id, ads.title AS ad_title, SUM(order_items.quantity) AS total_sold, ads.price AS ad_price, ads.media AS ad_media')
          .group('ads.id')
          .order('total_sold DESC')
          .limit(3)
          .map { |record| 
            { 
              ad_id: record.ad_id,
              ad_title: record.ad_title,
              total_sold: record.total_sold,
              ad_price: record.ad_price,
              ad_media: JSON.parse(record.ad_media || '[]') # Parse the media as an array
            } 
          }
  end
  

  def calculate_competitor_average_price(category_id)
    Vendor.joins(ads: :order_items)
          .where(ads: { category_id: category_id })
          .where.not(id: current_vendor.id)
          .average('ads.price')
          .to_f.round(2)
  end




  #===================================== HELPER METHODS =================================================#
  def calculate_total_orders
    current_vendor.orders.count
  end

  def calculate_total_revenue
    current_vendor.orders.joins(order_items: :ad).sum('order_items.quantity * ads.price')
  end

  def calculate_total_ads
    current_vendor.ads.count
  end

  def calculate_average_rating
    current_vendor.ads.joins(:reviews).average(:rating).to_f.round(1)
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

  def fetch_best_selling_ads
    current_vendor.ads.joins(:order_items)
                      .select('ads.id AS ad_id, ads.title AS ad_title, ads.price AS ad_price, SUM(order_items.quantity) AS total_sold, ads.media AS media')
                      .group('ads.id')
                      .order('total_sold DESC')
                      .limit(3)
                      .map { |record| 
                        {
                          ad_id: record.ad_id,
                          ad_title: record.ad_title,
                          ad_price: record.ad_price,
                          total_sold: record.total_sold,
                          media: record.media
                        }
                      }
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


# def calculate_wishlist_conversion_rate
#   ads = current_vendor.ads
#                       .joins("LEFT JOIN wish_lists ON wish_lists.ad_id = ads.id")
#                       .joins("LEFT JOIN order_items ON order_items.ad_id = ads.id")
#                       .select('ads.title AS ad_title, 
#                                 COUNT(wish_lists.id) AS wishlist_count, 
#                                 SUM(order_items.quantity) AS purchase_count')
#                       .group('ads.title')

#   # Calculate conversion rates and add fallback logic
#   processed_ads = ads.map do |ad|
#     wishlist_count = ad.wishlist_count.to_i
#     purchase_count = ad.purchase_count.to_i
#     conversion_rate = wishlist_count > 0 ? (purchase_count.to_f / wishlist_count) : 0

#     {
#       ad_title: ad.ad_title,
#       wishlist_count: wishlist_count,
#       purchase_count: purchase_count,
#       conversion_rate: conversion_rate
#     }
#   end

#   # Sort by conversion rate or wishlist count as a fallback
#   sorted_ads =  if processed_ads.any? { |ad| ad[:purchase_count] > 0 }
#                   processed_ads.sort_by { |ad| -ad[:conversion_rate] }
#                 else
#                     processed_ads.sort_by { |ad| -ad[:wishlist_count] }
#                 end

#   # Ensure it always returns an array
#   sorted_ads.first(3) || []
# end  

# def group_wishlist_by_age
#   WishList.joins(:purchaser)
#           .where(ads: { vendor_id: current_vendor.id })
#           .group("FLOOR(DATE_PART('year', AGE(purchasers.birthdate)) / 5) * 5")
#           .count
#           .transform_keys do |k|
#             { age_group: "#{k}–#{k.to_i + 4}" }
#           end
# end
# 
# Wishlist Stats with Demographics
# def calculate_wishlist_stats
#   {
#     wishlist_trends: calculate_wishlist_trends,
#     top_wishlisted_products: fetch_top_wishlisted_products,
#     wishlist_conversion_rate: calculate_wishlist_conversion_rate,
#     wishlist_by_age_groups: group_wishlist_by_age,
#     wishlist_by_income_ranges: group_wishlist_by_income,
#     wishlist_by_education_levels: group_wishlist_by_education,
#     wishlist_by_employment_statuses: group_wishlist_by_employment,
#     wishlist_by_sectors: group_wishlist_by_sector
#   }
# end