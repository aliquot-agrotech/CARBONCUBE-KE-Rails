# app/serializers/product_serializer.rb
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :quantity, :brand, :manufacturer
  has_one :vendor, serializer: VendorSerializer
  has_many :reviews

  def vendor_name
    object.vendor.name
  end
end
