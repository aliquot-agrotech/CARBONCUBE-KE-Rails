class MpesaController < ApplicationController
  skip_before_action :verify_authenticity_token 

  def validate_payment
    data = JSON.parse(request.body.read)
    account_number = data["BillRefNumber"]

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

    vendor = Vendor.find_by(phone_number: account_number) || Vendor.find_by(business_registration_number: account_number)

    # Save payment transaction
    Payment.create!(
      transaction_type: data["TransactionType"],
      trans_id: data["TransID"],
      trans_time: data["TransTime"],
      trans_amount: data["TransAmount"],
      business_short_code: data["BusinessShortCode"],
      bill_ref_number: data["BillRefNumber"],
      invoice_number: data["InvoiceNumber"],
      org_account_balance: data["OrgAccountBalance"],
      third_party_trans_id: data["ThirdPartyTransID"],
      msisdn: data["MSISDN"],
      first_name: data["FirstName"],
      middle_name: data["MiddleName"],
      last_name: data["LastName"]
    )

    if vendor
      tier = Tier.find_by(price: amount)

      if tier
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
