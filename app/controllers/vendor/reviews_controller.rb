class Vendor::ReviewsController < ApplicationController
  before_action :authenticate_vendor
  before_action :current_vendor

  def index
    @reviews = Review.joins(:ad).where(ads: { vendor_id: @current_vendor.id })
    render json: @reviews
  end

  def show
    @review = Review.find(params[:id])
    render json: @review
  end

  # POST /vendor/reviews/:id/reply
  def reply
    @review = Review.find(params[:id])
    @review.update(reply: params[:reply])  # Ensure 'reply' matches the attribute name in your Review model
    render json: @review
  end

  private

  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def current_vendor
    @current_vendor = @current_user
  end
end
