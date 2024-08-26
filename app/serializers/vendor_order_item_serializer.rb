class VendorOrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product_title, :price

  def product_title
    object.product&.title || 'Unknown Product'
  end

  def price
    object.product&.price || 0
  end
end
