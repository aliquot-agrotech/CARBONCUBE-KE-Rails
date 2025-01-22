class AdsController < ApplicationController
  # GET /ads
  def index
    # Fetch ads from vendors who are subscribed to the "Premium" tier
    @ads = Ad.joins(:vendor => :vendor_tier)
             .where(vendor_tiers: { tier_id: 4 }) # Tier ID 4 corresponds to "Premium"
             .where(vendors: { blocked: false }) # Ensure the vendor is not blocked
             .where(flagged: false) # Exclude flagged ads
             .distinct
             .sample(3) # Select three random ads

    render json: @ads, each_serializer: AdSerializer
  end
end

