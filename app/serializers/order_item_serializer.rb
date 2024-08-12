# app/serializers/order_item_serializer.rb
class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :product_id, :quantity, :product_name, :price, :vendor_name

  belongs_to :order
  belongs_to :product, serializer: ProductSerializer

  def product_name
    object.product.title
  end

  def price
    object.product.price
  end

  def vendor_name
    object.product.vendor.fullname
  end
end
