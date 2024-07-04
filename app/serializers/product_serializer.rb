# app/serializers/product_serializer.rb
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :quantity, :brand, :manufacturer
end
