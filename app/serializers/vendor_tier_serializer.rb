class VendorTierSerializer < ActiveModel::Serializer
  attributes :id, :vendor_id, :tier_id, :duration_months, :created_at, :updated_at, :subscription_countdown

  def subscription_countdown
    object.subscription_countdown
  end
end
