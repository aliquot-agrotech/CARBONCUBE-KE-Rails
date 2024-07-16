class VendorOrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product_name, :price

  def product_name
    object.product.title
  end

  def price
    object.product.price
  end
end
