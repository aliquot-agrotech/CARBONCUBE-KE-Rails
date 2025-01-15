# app/serializers/order_item_serializer.rb
class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :ad_id, :quantity, :ad_name, :price, :vendor_name

  belongs_to :order
  belongs_to :ad, serializer: AdSerializer

  def ad_name
    object.ad&.title || 'Unknown Ad'
  end

  def price
    object.ad&.price || 0
  end

  def vendor_name
    object.ad&.vendor&.fullname || 'Unknown Vendor'
  end
end
