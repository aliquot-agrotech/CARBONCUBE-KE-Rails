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
    tier_duration = params[:tier_duration].to_i # Convert the string to an integer (e.g., "6 months" => 6)
  
    if @current_vendor.update(tier_id: tier.id, tier_duration: tier_duration)
      render json: { message: 'Tier updated successfully' }, status: :ok
    else
      render json: { error: 'Tier update failed', details: @current_vendor.errors.full_messages }, status: :unprocessable_entity
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
