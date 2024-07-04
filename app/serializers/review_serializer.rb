class ReviewSerializer < ActiveModel::Serializer
    attributes :id, :rating, :review, :created_at, :updated_at
  
    belongs_to :product
    belongs_to :purchaser
end
  