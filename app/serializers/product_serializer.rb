# app/serializers/product_serializer.rb
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :vendor_id, :category_id, :subcategory_id, :title, :description, :price, :quantity, :brand, :manufacturer, :package_weight, :package_length, :package_width, :package_height, :media_urls, :first_media_url

  
  has_one :vendor, serializer: VendorSerializer
  has_many :reviews

  def media_urls
    object.media
  end


  def vendor_name
    object.vendor.name
  end
end
