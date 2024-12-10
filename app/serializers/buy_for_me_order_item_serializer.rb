# app/serializers/buy_for_me_order_item_serializer.rb
class BuyForMeOrderItemSerializer < ActiveModel::Serializer
  attributes :id, :buy_for_me_order_id, :product_id, :quantity, :product_name, :price, :vendor_name

  belongs_to :buy_for_me_order
  belongs_to :product, serializer: ProductSerializer

  def product_name
    object.product&.title || 'Unknown Product'
  end

  def price
    object.product&.price || 0
  end

  def vendor_name
    object.product&.vendor&.fullname || 'Unknown Vendor'
  end
end
