class OrderVendorSerializer < ActiveModel::Serializer
  attributes :id, :vendor_name

  belongs_to :order
  belongs_to :vendor

  def vendor_name
    object.vendor.fullname
  end
end