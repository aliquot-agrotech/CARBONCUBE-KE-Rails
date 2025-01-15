class AdSerializer < ActiveModel::Serializer
  attributes :id, :vendor_id, :category_id, :subcategory_id, :category_name, 
  :subcategory_name, :title, :description, :price, :quantity, :brand, 
  :manufacturer, :item_weight, :weight_unit, :item_length, :item_width, 
  :item_height, :media_urls, :first_media_url, :mean_rating, :review_count, :vendor_tier, :tier_name

  has_one :vendor, serializer: VendorSerializer
  has_many :reviews

  def media_urls
    object.media
  end

  def first_media_url
    object.media.first.try(:url)
  end

  def vendor_name
    object.vendor.name
  end

  def vendor_tier
    object.vendor.tier_id
  end

  def tier_name
    # Assuming you have a Tier model that stores tier names
    tier = object.vendor.tier
    tier ? tier.name : 'Unknown' # Return the name of the tier, or 'Unknown' if no tier exists
  end

  # Add these methods to fetch the names
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
