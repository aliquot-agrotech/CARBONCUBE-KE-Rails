class Vendor::MpesaController < ApplicationController
  # skip_before_action :verify_authenticity_token # Allow external API calls

  def validate_payment
    data = JSON.parse(request.body.read)
    account_number = data["BillRefNumber"]

    # Check if account number matches either phone_number or business_registration_number
    vendor = Vendor.find_by(phone_number: account_number) || Vendor.find_by(business_registration_number: account_number)

    if vendor
      render json: { ResultCode: 0, ResultDesc: "Accepted" }
    else
      render json: { ResultCode: "C2B00012", ResultDesc: "Invalid Account Number" }
    end
  end

  def confirm_payment
    data = JSON.parse(request.body.read)
    account_number = data["BillRefNumber"]
    amount_paid = data["TransAmount"].to_f

    # Find vendor using phone_number or business_registration_number
    vendor = Vendor.find_by(phone_number: account_number) || Vendor.find_by(business_registration_number: account_number)

    if vendor
      # Find the correct tier and duration based on the amount paid
      tier_pricing = TierPricing.where("price <= ?", amount_paid).order(price: :desc).first

      if tier_pricing
        tier = tier_pricing.tier
        duration_months = tier_pricing.duration_months

        # Find or create vendor's tier
        vendor_tier = VendorTier.find_or_initialize_by(vendor_id: vendor.id)

        vendor_tier.update!(
          tier_id: tier.id,
          duration_months: duration_months
        )

        render json: { ResultCode: 0, ResultDesc: "Payment Successful", tier: tier.name, duration_months: duration_months }
      else
        render json: { ResultCode: "C2B00014", ResultDesc: "Invalid Payment Amount" }
      end
    else
      render json: { ResultCode: "C2B00012", ResultDesc: "Invalid Account Number" }
    end
  end
end
  