# app/serializers/wish_list_serializer.rb
class WishListSerializer < ActiveModel::Serializer
  attributes :id, :purchaser_id, :ad_id, :created_at, :updated_at

  belongs_to :ad
end
