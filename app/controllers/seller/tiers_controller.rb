class Seller::TiersController < ApplicationController
  before_action :authenticate_seller

  def update_tier
    Rails.logger.info "🛠 SELLER ID CHECK: @current_seller.id = #{@current_seller&.id}"

    unless @current_seller
      return render json: { error: 'Seller not found or not authenticated' }, status: :unauthorized
    end

    tier = Tier.find_by(id: params[:tier_id])
    return render json: { error: 'Invalid tier selected' }, status: :not_found unless tier

    # Extract numeric duration from the string (e.g., "6 months" => 6)
    tier_duration = params[:tier_duration].to_i

    # 🔥 Find the existing seller_tier record (MUST EXIST)
    seller_tier = SellerTier.find_by(seller_id: @current_seller.id)

    if seller_tier
      # ✅ Update only, no creation
      if seller_tier.update(tier_id: tier.id, duration_months: tier_duration)
        render json: seller_tier, serializer: SellerTierSerializer, status: :ok
      else
        render json: { error: 'Tier update failed', details: seller_tier.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # 🚫 If no existing record, return an error
      render json: { error: 'Seller tier record not found. Update failed.' }, status: :not_found
    end
  end

  private

  def authenticate_seller
    @current_seller = SellerAuthorizeApiRequest.new(request.headers).result
    if @current_seller.nil?
      Rails.logger.error "❌ AUTHENTICATION FAILED: @current_seller is nil"
      render json: { error: 'Not Authorized' }, status: :unauthorized
    else
      Rails.logger.info "✅ AUTHENTICATION SUCCESS: Seller ID = #{@current_seller.id}"
    end
  end  
end
