class AdSerializer < ActiveModel::Serializer
    attributes  :id, :seller_id, :category_id, :subcategory_id, :category_name,
                :subcategory_name, :title, :description, :price, :quantity, :brand,
                :manufacturer, :item_weight, :weight_unit, :item_length, :item_width,
                :item_height, :media_urls, :first_media_url, :mean_rating, :review_count,
                :seller_tier, :tier_name, :condition, :seller_enterprise_name, :seller_phone_number,
                :seller_profile_picture, :seller_name

  has_one :seller, serializer: SellerSerializer
  has_many :reviews

  def media_urls
    object.media # ✅ Directly return the array of URLs
  end

  def first_media_url
    object.media.first # ✅ Return the first URL directly
  end

  def seller_name
    object.seller.fullname
  end

  def seller_tier
    seller_tier = object.seller.seller_tier
    seller_tier ? seller_tier.tier_id : nil
  end

  def tier_name
    seller_tier = object.seller.seller_tier
    seller_tier&.tier&.name || 'Unknown'
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

  def seller_enterprise_name
    object.seller.enterprise_name
  end

  def seller_profile_picture
    object.seller.profile_picture
  end

  def seller_phone_number
    object.seller.phone_number || "N/A"
  end
end
