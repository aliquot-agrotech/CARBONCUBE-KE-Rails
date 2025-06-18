class Seller::SellerTiersController < ApplicationController
  before_action :authenticate_seller


  def index
    @tiers = Tier.includes(:tier_features, :tier_pricings).all
    render json: @tiers.to_json(include: [:tier_features, :tier_pricings])
  end
  
  def show
    # Check for seller_id or fallback to id
    seller_id = params[:seller_id] || params[:id]

    # Find the most recent seller tier entry for this seller
    seller_tier = SellerTier.where(seller_id: seller_id).order(updated_at: :desc).first

    if seller_tier
      # Call the subscription_countdown method on the seller_tier instance
      countdown = seller_tier.subscription_countdown

      # Check if the countdown is expired
      if countdown[:expired]
        render json: {
          seller_id: seller_tier.seller_id,
          tier_id: seller_tier.tier_id,
          subscription_countdown: countdown,
          message: "Your subscription has expired."
        }
      else
        render json: {
          seller_id: seller_tier.seller_id,
          tier_id: seller_tier.tier_id,
          subscription_countdown: countdown
        }
      end
    else
      render json: { error: "Seller tier not found." }, status: :not_found
    end
  end

  def update_tier
    Rails.logger.info "🛠 VENDOR ID CHECK: @current_seller.id = #{@current_seller&.id}"

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
