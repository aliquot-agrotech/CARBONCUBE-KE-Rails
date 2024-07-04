# app/serializers/order_serializer.rb
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_amount, :is_sent_out, :is_processing, :is_delivered, :created_at, :updated_at
  belongs_to :purchaser
  has_many :order_items

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
