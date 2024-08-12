# app/serializers/order_serializer.rb
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :purchaser_id, :status, :total_amount, :mpesa_transaction_code, :created_at, :updated_at
  belongs_to :purchaser, serializer: PurchaserSerializer
  has_many :order_items, serializer: OrderItemSerializer

  def total_amount
    object.order_items.sum { |item| item.quantity * item.product.price }
  end

  def order_items
    object.order_items.map do |item|
      {
        id: item.id,
        quantity: item.quantity,
        product_name: item.product.title,
        price: item.product.price,
        vendor_name: item.product.vendor.fullname
      }
    end
  end
end
