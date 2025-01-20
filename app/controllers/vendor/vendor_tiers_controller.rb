# app/controllers/vendor_tiers_controller.rb
class Vendor::VendorTiersController < ApplicationController
  def show
    vendor_tier = VendorTier.where(vendor_id: params[:vendor_id]).order(updated_at: :desc).first

    if vendor_tier
      render json: {
        vendor_id: vendor_tier.vendor_id,
        tier_id: vendor_tier.tier_id,
        subscription_countdown: vendor_tier.subscription_countdown
      }
    else
      render json: { error: "No subscription found for this vendor." }, status: :not_found
    end
  end
end
