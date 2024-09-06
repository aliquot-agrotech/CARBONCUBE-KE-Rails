# app/serializers/order_serializer.rb
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :purchaser_id, :status, :total_amount, :mpesa_transaction_code, :created_at, :updated_at, :order_date
  belongs_to :purchaser, serializer: PurchaserSerializer
  has_many :order_items, serializer: OrderItemSerializer

  def total_amount
    object.order_items.sum { |item| item.quantity * item.product.price }
  end

  def order_date
    object.created_at.strftime('%Y-%m-%d')
  end
end
