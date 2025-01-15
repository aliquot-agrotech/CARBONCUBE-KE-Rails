class Admin::Vendor::ReviewsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_vendor
  before_action :set_ad

  def index
    @reviews = @ad.reviews
    render json: @reviews
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:vendor_id])
  end

  def set_ad
    @ad = @vendor.ads.find(params[:ad_id])
  end

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
  