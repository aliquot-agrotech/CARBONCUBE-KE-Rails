class AdsController < ApplicationController
  # GET /ads
  def index
    # Fetch ads from vendors subscribed to the premium tier
    @ads = Ad.joins(:vendor)
                      .where(vendors: { blocked: false, tier_id: 4 }) # Tier ID 4 corresponds to "Premium"
                      .where(flagged: false) # Exclude flagged ads
                      .distinct
                      .sample(3) # Select three random ads

    render json: @ads, each_serializer: AdSerializer
  end
end
