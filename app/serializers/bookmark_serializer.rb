# app/serializers/bookmark_serializer.rb
class BookmarkSerializer < ActiveModel::Serializer
  attributes :id, :purchaser_id, :product_id, :created_at, :updated_at

  belongs_to :product
end
