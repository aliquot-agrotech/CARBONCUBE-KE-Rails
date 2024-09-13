# app/serializers/product_serializer.rb
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :vendor_id, :category_id, :subcategory_id, :category_name, :subcategory_name, :title, :description, :price, :quantity, :brand, :manufacturer, :item_weight, :item_length, :item_width, :item_height, :media_urls, :first_media_url

  has_one :vendor, serializer: VendorSerializer
  has_many :reviews

  def media_urls
    object.media
  end

  def vendor_name
    object.vendor.name
  end

  # Add these methods to fetch the names
  def category_name
    object.category.name if object.category
  end

  def subcategory_name
    object.subcategory.name if object.subcategory
  end
end
  