class Vendor::TiersController < ApplicationController
  before_action :authenticate_vendor

  def index
    @tiers = Tier.includes(:tier_features, :tier_pricings).all
    render json: @tiers, each_serializer: TierSerializer
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Record not found: #{e.message}"
    render json: { error: 'No tiers found' }, status: :not_found
  rescue => e
    Rails.logger.error "Unexpected error: #{e.message}"
    render json: { error: 'Internal Server Error' }, status: :internal_server_error
  end

  def update_tier
    tier = Tier.find_by(id: params[:tier_id]) # Find the tier by the provided ID
  
    unless tier
      return render json: { error: 'Invalid tier selected' }, status: :not_found
    end
  
    # Extract numeric duration from the string (e.g., "6 months" => 6)
    tier_duration = params[:tier_duration].to_i
  
    # Find the existing vendor tier (regardless of tier_id)
    vendor_tier = VendorTier.where(vendor_id: @current_vendor.id).order(updated_at: :desc).first
  
    if vendor_tier
      # Update the vendor_tier with the new tier_id and duration
      if vendor_tier.update(tier_id: tier.id, duration_months: tier_duration)
        render json: vendor_tier, serializer: VendorTierSerializer, status: :ok
      else
        render json: { error: 'Tier update failed', details: vendor_tier.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # If no existing entry, create a new one
      new_vendor_tier = VendorTier.new(vendor_id: @current_vendor.id, tier_id: tier.id, duration_months: tier_duration)
      if new_vendor_tier.save
        render json: new_vendor_tier, serializer: VendorTierSerializer, status: :created
      else
        render json: { error: 'Failed to create new tier', details: new_vendor_tier.errors.full_messages }, status: :unprocessable_entity
      end
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
