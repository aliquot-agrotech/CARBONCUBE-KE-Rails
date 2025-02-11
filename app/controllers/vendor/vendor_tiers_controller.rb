class Vendor::VendorTiersController < ApplicationController

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
    tier = Tier.find_by(id: params[:tier_id]) # Find the tier by the provided ID

    unless tier
      return render json: { error: 'Invalid tier selected' }, status: :not_found
    end

    # Extract numeric duration from the string (e.g., "6 months" => 6)
    tier_duration = params[:tier_duration].to_i

    # Check if the vendor already has an entry in the vendor_tiers table
    vendor_tier = VendorTier.where(vendor_id: @current_vendor.id, tier_id: tier.id).order(updated_at: :desc).first

    if vendor_tier
      # Update the existing entry
      if vendor_tier.update(duration_months: tier_duration)
        render json: vendor_tier, serializer: VendorTierSerializer, status: :ok
      else
        render json: { error: 'Tier update failed', details: vendor_tier.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # Create a new entry in the vendor_tiers table
      new_vendor_tier = VendorTier.new(vendor_id: @current_vendor.id, tier_id: tier.id, duration_months: tier_duration)
      if new_vendor_tier.save
        render json: new_vendor_tier, serializer: VendorTierSerializer, status: :created
      else
        render json: { error: 'Failed to create new tier', details: new_vendor_tier.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
