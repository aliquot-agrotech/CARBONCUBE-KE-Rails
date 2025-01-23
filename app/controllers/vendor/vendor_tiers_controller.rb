class Vendor::VendorTiersController < ApplicationController
  def show
    # Find the most recent vendor tier entry for this vendor
    vendor_tier = VendorTier.where(vendor_id: params[:vendor_id]).order(updated_at: :desc).first

    if vendor_tier
      # Call the subscription_countdown method on the vendor_tier instance
      countdown = vendor_tier.subscription_countdown

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
      render json: { error: "No subscription found for this vendor." }, status: :not_found
    end
  end
end
