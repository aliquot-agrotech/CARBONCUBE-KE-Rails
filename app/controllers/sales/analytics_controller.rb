# app/controllers/sales/analytics_controller.rb
class Sales::AnalyticsController < ApplicationController
  before_action :authenticate_sales_user

  def index
    @total_sellers = Seller.where(deleted:false).count
    @total_buyers = Buyer.where(deleted:false).count
    @total_ads = Ad.count
    @total_reviews = Review.count
    total_ads_wish_listed = WishList.count


    paid_seller_tiers_count = SellerTier
    .joins(:seller)
    .where(tier_id: [2, 3, 4], sellers: { deleted: false })
    .count

    unpaid_seller_tiers = SellerTier
    .joins(:seller)
    .where(tier_id: 1, sellers: { deleted: false })
    .count

    total_ads_clicks = ClickEvent.where(event_type: 'Ad-Click').count

    buyer_ad_clicks = ClickEvent
    .joins(:buyer)  # assuming ClickEvent belongs_to :buyer
    .where(event_type: 'Ad-Click')
    .where(buyers: { deleted: false })
    .count


     category_click_events = Category.joins(ads: :click_events)
        .where.not(click_events: { buyer_id: nil })
        .select('categories.name AS category_name, 
                SUM(CASE WHEN click_events.event_type = \'Ad-Click\' THEN 1 ELSE 0 END) AS ad_clicks,
                SUM(CASE WHEN click_events.event_type = \'Add-to-Wish-List\' THEN 1 ELSE 0 END) AS wish_list_clicks,
                SUM(CASE WHEN click_events.event_type = \'Reveal-Seller-Details\' THEN 1 ELSE 0 END) AS reveal_clicks')
        .group('categories.id')
        .order('category_name')
        .map do |record| 
          {
            category_name: record.category_name,
            ad_clicks: record.ad_clicks,
            wish_list_clicks: record.wish_list_clicks,
            reveal_clicks: record.reveal_clicks
          }
        end


    

    render json: {
      total_sellers: @total_sellers,
      total_buyers: @total_buyers,
      total_ads: @total_ads,
      total_reviews: @total_reviews,
      total_ads_wish_listed: total_ads_wish_listed ,
      subscription_countdowns:paid_seller_tiers_count,
      without_subscription: unpaid_seller_tiers,
      total_ads_clicks: total_ads_clicks,
      category_click_events: category_click_events,
      buyer_ad_clicks: buyer_ad_clicks,
    }
  end

  private

  def authenticate_sales_user
  @current_sales_user = SalesAuthorizeApiRequest.new(request.headers).result
  unless @current_sales_user
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
end

 
end
