class Vendor::TiersController < ApplicationController
  before_action :authenticate_vendor

  def index
    @tiers = Tier.includes(:tier_features, :tier_pricings).all
    render json: @tiers, each_serializer: TierSerializer
  end

  def update_tier
    tier = Tier.find_by(id: params[:tier_id])
    unless tier
      return render json: { error: 'Invalid tier selected' }, status: :not_found
    end
  
    if @vendor.update(tier_id: tier.id)
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
