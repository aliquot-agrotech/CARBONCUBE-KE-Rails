# app/serializers/wish_list_serializer.rb
class WishListSerializer < ActiveModel::Serializer
  attributes :id, :purchaser_id, :product_id, :created_at, :updated_at

  belongs_to :product
end
