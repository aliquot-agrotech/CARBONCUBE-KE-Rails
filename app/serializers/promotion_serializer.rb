class PromotionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :discount_percentage, :start_date, :end_date, :vendor_id

  belongs_to :vendor
end
