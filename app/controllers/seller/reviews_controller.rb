class Seller::ReviewsController < ApplicationController
  before_action :authenticate_seller
  before_action :current_seller

  def index
    @reviews = Review.joins(:ad).where(ads: { seller_id: @current_seller.id })
    render json: @reviews
  end

  def show
    @review = Review.find(params[:id])
    render json: @review
  end

  # POST /seller/reviews/:id/reply
  def reply
    @review = Review.find(params[:id])
    @review.update(reply: params[:reply])  # Ensure 'reply' matches the attribute name in your Review model
    render json: @review
  end

  private

  def authenticate_seller
    @current_user = SellerAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Seller)
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def current_seller
    @current_seller = @current_user
  end
end
