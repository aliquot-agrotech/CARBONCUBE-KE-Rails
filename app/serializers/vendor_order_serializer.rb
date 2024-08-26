class VendorOrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_price, :order_date, :created_at, :updated_at

  has_many :order_items, serializer: VendorOrderItemSerializer

  def order_items
    object.order_items.select { |item| item.product.vendor_id == scope.id }
  end

  def total_price
    object.order_items.sum { |item| item.quantity * (item.product&.price || 0) }
  end

  def order_date
    object.created_at.to_date.strftime('%Y-%m-%d') # Adjust format as needed
  end
end
