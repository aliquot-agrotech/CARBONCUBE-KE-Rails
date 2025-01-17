class Vendor::AnalyticsController < ApplicationController
  before_action :authenticate_vendor

  def index
    # Get vendor's tier_id
    tier_id = current_vendor.tier_id

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
      response_data.merge!(wishlist_stats: calculate_wishlist_stats)
    when 4 # Premium tier
      response_data.merge!(calculate_premium_tier_data)
      response_data.merge!(
        wishlist_stats: calculate_wishlist_stats,
        competitor_stats: calculate_competitor_stats
      )
    else
      render json: { error: 'Invalid tier' }, status: 400
      return
    end

    render json: response_data
  end

  private

  # Data for Free tier (id: 1)
  def calculate_free_tier_data
    {
      total_orders: calculate_total_orders,
      total_ads: calculate_total_ads,
      average_rating: calculate_average_rating
    }
  end

  # Data for Basic tier (id: 2)
  def calculate_basic_tier_data
    {
      total_revenue: calculate_total_revenue
    }
  end

  # Data for Standard tier (id: 3)
  def calculate_standard_tier_data
    {
      total_revenue: calculate_total_revenue,
      total_reviews: calculate_total_reviews,
      sales_performance: calculate_sales_performance,
      best_selling_ads: fetch_best_selling_ads
    }
  end

  # Data for Premium tier (id: 4)
  def calculate_premium_tier_data
    {
      total_revenue: calculate_total_revenue,
      average_rating: calculate_average_rating,
      total_reviews: calculate_total_reviews,
      sales_performance: calculate_sales_performance,
      best_selling_ads: fetch_best_selling_ads
    }
  end

  # Wishlist Stats
  def calculate_wishlist_stats
    {
      top_wishlisted_products: fetch_top_wishlisted_products,
      wishlist_conversion_rate: calculate_wishlist_conversion_rate,
      wishlist_trends: calculate_wishlist_trends
    }
  end

  def fetch_top_wishlisted_products
    WishList.joins(:ad)
            .where(ads: { vendor_id: current_vendor.id })
            .group('ads.id', 'ads.title')  # Add 'ads.title' to the GROUP BY clause
            .select('ads.title AS ad_title, COUNT(wish_lists.id) AS wishlist_count')
            .order('wishlist_count DESC')
            .limit(3)
            .map { |record| { ad_title: record.ad_title, wishlist_count: record.wishlist_count } }
  end    

  # def calculate_top_conversion_ads
  #   current_vendor.ads
  #                 .joins("LEFT JOIN wish_lists ON wish_lists.ad_id = ads.id")
  #                 .joins("LEFT JOIN order_items ON order_items.ad_id = ads.id")
  #                 .select('ads.title AS ad_title, COUNT(wish_lists.id) AS wishlist_count, SUM(order_items.quantity) AS purchase_count')
  #                 .group('ads.title') # Ensure grouping by ad title
  #                 .map { |ad| 
  #                   {
  #                     ad_title: ad.ad_title,
  #                     wishlist_count: ad.wishlist_count,
  #                     purchase_count: ad.purchase_count || 0,
  #                     conversion_rate: ad.wishlist_count.to_f > 0 ? (ad.purchase_count.to_f / ad.wishlist_count) * 100 : 0 # Calculate conversion rate
  #                   }
  #                 }
  #                 .sort_by { |ad| -ad[:conversion_rate] } # Sort by highest conversion rate
  #                 .take(3) # Limit to top 3
  # end

  def calculate_top_conversion_ads
    ads = current_vendor.ads
                        .joins("LEFT JOIN wish_lists ON wish_lists.ad_id = ads.id")
                        .joins("LEFT JOIN order_items ON order_items.ad_id = ads.id")
                        .select('ads.title AS ad_title, 
                                COUNT(wish_lists.id) AS wishlist_count, 
                                SUM(order_items.quantity) AS purchase_count')
                        .group('ads.title')
    # Calculate conversion rates and add fallback logic
    processed_ads = ads.map do |ad|
      wishlist_count = ad.wishlist_count.to_i
      purchase_count = ad.purchase_count.to_i
      conversion_rate = wishlist_count > 0 ? (purchase_count.to_f / wishlist_count) : 0
      {
        ad_title: ad.ad_title,
        wishlist_count: wishlist_count,
        purchase_count: purchase_count,
        conversion_rate: conversion_rate
      }
    end
  
    # Sort by conversion rate or wishlist count as a fallback
    sorted_ads = if processed_ads.any? { |ad| ad[:purchase_count] > 0 }
                  processed_ads.sort_by { |ad| -ad[:conversion_rate] }
                else
                  processed_ads.sort_by { |ad| -ad[:wishlist_count] }
                end
  
    # Return top 3 ads
    sorted_ads.first(3)
  end

  def calculate_wishlist_trends
    WishList.joins(:ad)
            .where(ads: { vendor_id: current_vendor.id })
            .group('DATE_TRUNC(\'month\', wish_lists.created_at)', 'ads.title')  # Ensure both fields are grouped
            .count
            .transform_keys { |k| { month: k[0].strftime("%B %Y"), ad_title: k[1] } }
  end  

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

  # Helper Methods (unchanged)
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
