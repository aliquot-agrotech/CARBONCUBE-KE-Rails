class Vendor::TiersController < ApplicationController
  before_action :authenticate_vendor

  def index
    @tiers = Tier.includes(:tier_features, :tier_pricings).all
    render json: @tiers.to_json(include: [:tier_features, :tier_pricings])
  end


  def update_tier
    @vendor = Vendor.find(params[:id])
    if @vendor.update(tier_id: params[:tier_id])
      render json: { message: 'Tier updated successfully' }, status: :ok
    else
      render json: { error: 'Tier update failed' }, status: :unprocessable_entity
    end
  end

  private 

  def authenticate_vendor
    @current_vendor = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_vendor
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
end
