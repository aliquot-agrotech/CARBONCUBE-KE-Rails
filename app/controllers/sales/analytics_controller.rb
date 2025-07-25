# app/controllers/sales/analytics_controller.rb
class Sales::AnalyticsController < ApplicationController
  before_action :authenticate_sales_user

  def index
    @total_sellers = Seller.count
    @total_buyers = Buyer.count
    @total_ads = Ad.count
    @total_reviews = Review.count
    total_ads_wish_listed = WishList.count

    

    render json: {
      total_sellers: @total_sellers,
      total_buyers: @total_buyers,
      total_ads: @total_ads,
      total_reviews: @total_reviews,
      total_ads_wish_listed: total_ads_wish_listed ,

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
