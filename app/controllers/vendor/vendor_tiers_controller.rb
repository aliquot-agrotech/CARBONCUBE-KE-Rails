class Vendor::VendorTiersController < ApplicationController
  before_action :authenticate_vendor


  def index
    @tiers = Tier.includes(:tier_features, :tier_pricings).all
    render json: @tiers.to_json(include: [:tier_features, :tier_pricings])
  end
  
  def show
    # Check for vendor_id or fallback to id
    vendor_id = params[:vendor_id] || params[:id]

    # Find the most recent vendor tier entry for this vendor
    vendor_tier = VendorTier.where(vendor_id: vendor_id).order(updated_at: :desc).first

    if vendor_tier
      # Call the subscription_countdown method on the vendor_tier instance
      countdown = vendor_tier.subscription_countdown

      # Check if the countdown is expired
      if countdown[:expired]
        render json: {
          vendor_id: vendor_tier.vendor_id,
          tier_id: vendor_tier.tier_id,
          subscription_countdown: countdown,
          message: "Your subscription has expired."
        }
      else
        render json: {
          vendor_id: vendor_tier.vendor_id,
          tier_id: vendor_tier.tier_id,
          subscription_countdown: countdown
        }
      end
    else
      render json: { error: "Vendor tier not found." }, status: :not_found
    end
  end

  def update_tier
    Rails.logger.info "🛠 VENDOR ID CHECK: @current_vendor.id = #{@current_vendor&.id}"

    unless @current_vendor
      return render json: { error: 'Vendor not found or not authenticated' }, status: :unauthorized
    end

    tier = Tier.find_by(id: params[:tier_id])
    return render json: { error: 'Invalid tier selected' }, status: :not_found unless tier

    # Extract numeric duration from the string (e.g., "6 months" => 6)
    tier_duration = params[:tier_duration].to_i

    # 🔥 Find the existing vendor_tier record (MUST EXIST)
    vendor_tier = VendorTier.find_by(vendor_id: @current_vendor.id)

    if vendor_tier
      # ✅ Update only, no creation
      if vendor_tier.update(tier_id: tier.id, duration_months: tier_duration)
        render json: vendor_tier, serializer: VendorTierSerializer, status: :ok
      else
        render json: { error: 'Tier update failed', details: vendor_tier.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # 🚫 If no existing record, return an error
      render json: { error: 'Vendor tier record not found. Update failed.' }, status: :not_found
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
