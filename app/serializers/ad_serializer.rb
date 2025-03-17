class AdSerializer < ActiveModel::Serializer
  attributes :id, :vendor_id, :category_id, :subcategory_id, :category_name,
             :subcategory_name, :title, :description, :price, :quantity, :brand,
             :manufacturer, :item_weight, :weight_unit, :item_length, :item_width,
             :item_height, :media_urls, :first_media_url, :mean_rating, :review_count,
             :vendor_tier, :tier_name

  has_one :vendor, serializer: VendorSerializer
  has_many :reviews

  def media_urls
    object.media.map { |m| m.url } # ✅ Ensure media_urls contains only URLs
  end

  def first_media_url
    object.media.first&.url # ✅ Get the first image URL safely
  end

  def vendor_name
    object.vendor.name
  end

  def vendor_tier
    vendor_tier = object.vendor.vendor_tier
    vendor_tier ? vendor_tier.tier_id : nil
  end

  def tier_name
    vendor_tier = object.vendor.vendor_tier
    vendor_tier&.tier&.name || 'Unknown'
  end

  def category_name
    object.category.name if object.category
  end

  def subcategory_name
    object.subcategory.name if object.subcategory
  end

  def mean_rating
    object.reviews.average(:rating).to_f
  end

  def review_count
    object.reviews.count
  end
end
