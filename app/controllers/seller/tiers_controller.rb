class Seller::TiersController < ApplicationController
  before_action :authenticate_vendor

  def update_tier
    Rails.logger.info "🛠 VENDOR ID CHECK: @current_vendor.id = #{@current_vendor&.id}"

    unless @current_vendor
      return render json: { error: 'Seller not found or not authenticated' }, status: :unauthorized
    end

    tier = Tier.find_by(id: params[:tier_id])
    return render json: { error: 'Invalid tier selected' }, status: :not_found unless tier

    # Extract numeric duration from the string (e.g., "6 months" => 6)
    tier_duration = params[:tier_duration].to_i

    # 🔥 Find the existing vendor_tier record (MUST EXIST)
    vendor_tier = SellerTier.find_by(vendor_id: @current_vendor.id)

    if vendor_tier
      # ✅ Update only, no creation
      if vendor_tier.update(tier_id: tier.id, duration_months: tier_duration)
        render json: vendor_tier, serializer: SellerTierSerializer, status: :ok
      else
        render json: { error: 'Tier update failed', details: vendor_tier.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # 🚫 If no existing record, return an error
      render json: { error: 'Seller tier record not found. Update failed.' }, status: :not_found
    end
  end

  private

  def authenticate_vendor
    @current_vendor = SellerAuthorizeApiRequest.new(request.headers).result
    if @current_vendor.nil?
      Rails.logger.error "❌ AUTHENTICATION FAILED: @current_vendor is nil"
      render json: { error: 'Not Authorized' }, status: :unauthorized
    else
      Rails.logger.info "✅ AUTHENTICATION SUCCESS: Seller ID = #{@current_vendor.id}"
    end
  end  
end
