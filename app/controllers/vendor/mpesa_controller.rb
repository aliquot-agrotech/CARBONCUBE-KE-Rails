class Vendor::MpesaController < ApplicationController
  # skip_before_action :verify_authenticity_token

  def validate_payment
    data = JSON.parse(request.body.read)
    account_number = data["BillRefNumber"]

    # Find vendor by phone_number or business_registration_number
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
    amount = data["TransAmount"].to_f

    # Find the vendor by phone number or business registration number
    vendor = Vendor.find_by(phone_number: account_number) || Vendor.find_by(business_registration_number: account_number)

    if vendor
      # Determine which tier the vendor paid for
      tier = Tier.find_by(price: amount)  # Assuming `price` is stored in Tier model

      if tier
        # Update vendor tier duration
        vendor_tier = VendorTier.find_or_initialize_by(vendor_id: vendor.id)
        vendor_tier.update(tier_id: tier.id, duration_months: tier.duration_months)

        render json: { ResultCode: 0, ResultDesc: "Success" }
      else
        render json: { ResultCode: "C2B00013", ResultDesc: "Invalid Amount - No Matching Tier" }
      end
    else
      render json: { ResultCode: "C2B00012", ResultDesc: "Invalid Account Number" }
    end
  end
end
