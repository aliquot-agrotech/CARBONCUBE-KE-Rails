class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product_name

  belongs_to :order
  belongs_to :product

  def product_name
    object.product.title
  end
end