class Vendor::TiersController < ApplicationController
  before_action :authenticate_vendor

  def update_tier
    Rails.logger.info "🛠 VENDOR ID CHECK: @current_vendor.id = #{@current_vendor&.id}"
  
    unless @current_vendor
      return render json: { error: 'Vendor not found or not authenticated' }, status: :unauthorized
    end
  
    tier = Tier.find_by(id: params[:tier_id])
  
    unless tier
      return render json: { error: 'Invalid tier selected' }, status: :not_found
    end
  
    # Extract numeric duration from the string (e.g., "6 months" => 6)
    tier_duration = params[:tier_duration].to_i
  
    # Check if the vendor already has a record
    vendor_tier = VendorTier.where(vendor_id: @current_vendor.id).order(updated_at: :desc).first
  
    if vendor_tier
      # Update the vendor's existing tier entry
      if vendor_tier.update(tier_id: tier.id, duration_months: tier_duration)
        render json: vendor_tier, serializer: VendorTierSerializer, status: :ok
      else
        render json: { error: 'Tier update failed', details: vendor_tier.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # Create a new entry if none exists
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
    if @current_vendor.nil?
      Rails.logger.error "❌ AUTHENTICATION FAILED: @current_vendor is nil"
      render json: { error: 'Not Authorized' }, status: :unauthorized
    else
      Rails.logger.info "✅ AUTHENTICATION SUCCESS: Vendor ID = #{@current_vendor.id}"
    end
  end  
end
