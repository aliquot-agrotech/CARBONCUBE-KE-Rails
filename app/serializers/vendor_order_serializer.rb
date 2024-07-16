class VendorOrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_amount, :created_at, :updated_at

  has_many :order_items, serializer: VendorOrderItemSerializer

  def order_items
    object.order_items.select { |item| item.product.vendor_id == scope.id }
  end
end

